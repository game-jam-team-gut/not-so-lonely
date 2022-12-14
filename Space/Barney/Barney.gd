extends KinematicBody2D

signal robot_sticked(pos)

onready var magneticFieldcollisionShape2D = get_node("Rotates/MagneticField/CollisionShape2D")
onready var magneticFieldSprite = get_node("Rotates/MagneticField/CollisionShape2D/Sprite")
onready var stickedRobotScene = preload("res://Space/StickedRobot.tscn")

export (int) var speed = 200
export (int) var magneticFieldForceFactor = 4

var targetPosition = Vector2()
var velocity = Vector2()
var magneticFieldType = -1 # -1 - sticking field, 1 - repulsive field

func apply_magnetic_force(area, delta):
	if area.is_in_group("ForeignRobots") or area.is_in_group("Asteroid"):
		var foreignRobot = area.get_parent()
		var positionDifference = foreignRobot.position - self.position
		
		if(positionDifference.x < 0):
			foreignRobot.add_force(Vector2(0, 0), Vector2(magneticFieldType * magneticFieldForceFactor * delta * positionDifference.x, 0))
		elif(positionDifference.x > 0):
			foreignRobot.add_force(Vector2(0, 0), Vector2(magneticFieldType * magneticFieldForceFactor * delta * positionDifference.x, 0))
		if(positionDifference.y < 0):
			foreignRobot.add_force(Vector2(0, 0), Vector2(0, magneticFieldType * magneticFieldForceFactor * delta * positionDifference.y))
		elif(positionDifference.y > 0):
			foreignRobot.add_force(Vector2(0, 0), Vector2(0, magneticFieldType * magneticFieldForceFactor * delta * positionDifference.y))

func rotate_barney():
	get_node("Rotates").look_at(get_global_mouse_position())

func check_movement():
	if Input.is_action_pressed("m1"):
		targetPosition = get_global_mouse_position()
	else:
		targetPosition = position

func check_magnetic_field_type():
	if Input.is_action_pressed("m2"):
		magneticFieldType = 1
	else:
		magneticFieldType = -1

func get_input():
	check_movement()
	check_magnetic_field_type()

func update_magnetic_field_size():
	var sizeChange = get_viewport().size.x * 0.25 * get_node("Camera2D").zoom.x
	magneticFieldcollisionShape2D.shape.extents.x += sizeChange - magneticFieldcollisionShape2D.position.x
	magneticFieldcollisionShape2D.position.x = sizeChange
	magneticFieldSprite.scale.x = 2 * magneticFieldcollisionShape2D.shape.extents.x / magneticFieldSprite.get_texture().get_size().x
	
func _ready():
	update_magnetic_field_size()

func check_magnetic_field_contents(delta):
	if get_node("Rotates/MagneticField").get_overlapping_areas().size() > 0:
		for area in get_node("Rotates/MagneticField").get_overlapping_areas():
				apply_magnetic_force(area, delta)

func move():
	velocity = position.direction_to(targetPosition) * speed
	if position.distance_to(targetPosition) > 5:
		velocity = move_and_slide(velocity)

func _physics_process(delta):
	check_magnetic_field_contents(delta)
	get_input()
	move()
	rotate_barney()

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
	elif area.is_in_group("Asteroid"):
		area.get_parent().destroy()
		get_tree().change_scene("res://MainMenu.tscn")

func robot_sticked_to_another(pos):
	emit_signal("robot_sticked", pos)

func destroy():
	print("DEATH")
