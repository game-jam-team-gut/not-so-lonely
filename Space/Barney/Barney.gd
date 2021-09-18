extends KinematicBody2D

signal robot_sticked(global_pos)

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
	var scaleChange = 0.02
	var originalScale = Vector2(2.2, 2.2)
	
	if Input.is_action_pressed("m2"):
		var newScale = Vector2 (collisionShape2D.scale.x + scaleChange, collisionShape2D.scale.y + scaleChange)
		collisionShape2D.scale = newScale
	else:
		var newScale = Vector2 (collisionShape2D.scale.x - scaleChange, collisionShape2D.scale.y - scaleChange)
		if newScale >= originalScale:
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
		var foreignRobotSprite = foreignRobot.get_node("foreign_robot").duplicate()
		var foreignRobotCollisionShape = foreignRobot.get_node("CollisionShape2D").duplicate()
		var foreignRobotRelativePosition = foreignRobot.position - self.position
		var foreignRobotGlobalRot = foreignRobot.global_rotation
		
		foreignRobotSprite.position = foreignRobotRelativePosition
		foreignRobotCollisionShape.position = foreignRobotRelativePosition
		
		foreignRobotSprite.global_rotation = foreignRobotGlobalRot
		foreignRobotCollisionShape.global_rotation = foreignRobotGlobalRot
		
		get_tree().get_current_scene().remove_child(area.get_parent())
		
		add_child(foreignRobotSprite)
		get_node("StickingField").call_deferred("add_child", foreignRobotCollisionShape)
		emit_signal("robot_sticked", foreignRobotSprite.global_position)
		
