extends KinematicBody2D

signal robot_sticked(pos)

onready var collisionShape2D = get_node("Rotates/MagneticField/CollisionShape2D")
onready var stickedRobotScene = preload("res://Space/StickedRobot.tscn")

export (int) var speed = 200

var targetPosition = Vector2()
var velocity = Vector2()
var minimalMagneticFieldPositionX

func _ready():
	minimalMagneticFieldPositionX = collisionShape2D.position.x

func rotate_barney():
	get_node("Rotates").look_at(get_global_mouse_position())

func check_movement():
	if Input.is_action_pressed("m1"):
		targetPosition = get_global_mouse_position()
	else:
		targetPosition = position

func check_magnetic_field():
	var xChange = 10.0
	
	if Input.is_action_pressed("m2"):
		if collisionShape2D.position.x < get_viewport().size.x * 0.25 * get_node("Camera2D").zoom.x:
			collisionShape2D.shape.extents.x += xChange
			collisionShape2D.position.x += xChange
	else:
		if collisionShape2D.position.x > minimalMagneticFieldPositionX:
			collisionShape2D.shape.extents.x -= xChange
			collisionShape2D.position.x -= xChange

func get_input():
	check_movement()
	check_magnetic_field()

func _physics_process(_delta):
	get_input()
	velocity = position.direction_to(targetPosition) * speed
	if position.distance_to(targetPosition) > 5:
		velocity = move_and_slide(velocity)
	rotate_barney()

func _on_MagneticField_area_entered(area):
	if area.is_in_group("ForeignRobots"):
		var foreignRobot = area.get_parent()
		var positionDifference = foreignRobot.position - self.position
		
		if(positionDifference.x < 0):
			foreignRobot.add_force(Vector2(0, 0), Vector2(-positionDifference.x, 0))
		elif(positionDifference.x > 0):
			foreignRobot.add_force(Vector2(0, 0), Vector2(-positionDifference.x, 0))
		if(positionDifference.y < 0):
			foreignRobot.add_force(Vector2(0, 0), Vector2(0, -positionDifference.y))
		elif(positionDifference.y > 0):
			foreignRobot.add_force(Vector2(0, 0), Vector2(0, -positionDifference.y))

func _on_StickingField_area_entered(area):
	if area.is_in_group("ForeignRobots"):
		var foreignRobot = area.get_parent()
		var foreignRobotRelativePosition = foreignRobot.position - self.position
		var foreignRobotRotation = foreignRobot.rotation
		var foreignRobotSprite = foreignRobot.get_node("Sprite").duplicate()
		var foreignRobotCollisionShape2D = foreignRobot.get_node("Area2D/CollisionShape2D").duplicate()
		
		foreignRobotSprite.position = foreignRobotRelativePosition
		foreignRobotCollisionShape2D.position =  foreignRobotRelativePosition
		
		foreignRobotSprite.rotation = foreignRobotRotation
		foreignRobotCollisionShape2D.rotation = foreignRobotRotation
		
		var stickedRobot = stickedRobotScene.instance()
		stickedRobot.player = self
		
		stickedRobot.add_child(foreignRobotSprite)
		stickedRobot.get_node("StickingField").call_deferred("add_child", foreignRobotCollisionShape2D)
		
		get_tree().get_current_scene().remove_child(area.get_parent())
		
		call_deferred("add_child", stickedRobot)
		
		emit_signal("robot_sticked", foreignRobotRelativePosition)

func robot_sticked_to_another(pos):
	emit_signal("robot_sticked", pos)
