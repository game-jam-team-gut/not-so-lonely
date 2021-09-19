extends KinematicBody2D

signal robot_sticked(global_pos)

onready var stickedRobotScene = preload("res://Space/StickedRobot.tscn")

export (int) var speed = 200

var targetPosition = Vector2()
var velocity = Vector2()

func check_movement():
	if Input.is_action_pressed("m1"):
		targetPosition = get_global_mouse_position()
	else:
		targetPosition = position

func check_magnetic_field():
	var collisionShape2D = get_node("MagneticField/CollisionShape2D")
	var minimalScale = Vector2(2.2, 2.2)
	var maximalScale = Vector2(minimalScale.x * 3, minimalScale.y * 3)
	var scaleChange = minimalScale.x / 16
	
	if Input.is_action_pressed("m2"):
		var newScale = Vector2 (collisionShape2D.scale.x + scaleChange, collisionShape2D.scale.y + scaleChange)
		if newScale <= maximalScale:
			collisionShape2D.scale = newScale
	else:
		var newScale = Vector2 (collisionShape2D.scale.x - scaleChange, collisionShape2D.scale.y - scaleChange)
		if newScale >= minimalScale:
			collisionShape2D.scale = newScale

func get_input():
	check_movement()
	check_magnetic_field()

func _physics_process(_delta):
	get_input()
	velocity = position.direction_to(targetPosition) * speed
	if position.distance_to(targetPosition) > 5:
		velocity = move_and_slide(velocity)

func _on_MagneticField_area_entered(area):
	if area.is_in_group("ForeignRobots"):
		var foreignRobot = area.get_parent()
		var positionDifference = foreignRobot.position - self.position
		print(positionDifference)
		
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
		
		var stickedRobot = stickedRobotScene.instance()
		var stickedRobotSprite = stickedRobot.get_node("sticked_robot")
		var stickedRobotCollisionShape2D = stickedRobot.get_node("StickingField/CollisionShape2D")
		
		stickedRobotSprite.position = foreignRobotRelativePosition
		stickedRobotCollisionShape2D.position = foreignRobotRelativePosition
		
		stickedRobotSprite.rotation = foreignRobotRotation
		stickedRobotCollisionShape2D.rotation = foreignRobotRotation
		
		get_tree().get_current_scene().remove_child(area.get_parent())
		
		call_deferred("add_child", stickedRobot)
		
		emit_signal("robot_sticked", stickedRobot.position)
		
