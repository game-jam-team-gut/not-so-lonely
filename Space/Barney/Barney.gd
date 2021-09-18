extends KinematicBody2D

export (int) var speed = 200

var targetPosition = Vector2()
var velocity = Vector2()

func get_input():
	if Input.is_action_pressed("m1"):
		targetPosition = get_global_mouse_position()
	else:
		targetPosition = position

func _physics_process(_delta):
	get_input()
	velocity = position.direction_to(targetPosition) * speed
	if position.distance_to(targetPosition) > 5:
		velocity = move_and_slide(velocity)

func _on_MagneticField_area_entered(area):
	if area.is_in_group("ForeignRobots"):
		pass #here add moving towards Barney


func _on_StickingField_area_entered(area):
	if area.is_in_group("ForeignRobots"):
		var foreignRobot = area.get_parent()
		var foreignRobotSprite = foreignRobot.get_node("foreign_robot").duplicate()
		var foreignRobotCollisionShape = foreignRobot.get_node("CollisionShape2D").duplicate()
		var foreignRobotRelativePosition = foreignRobot.position - self.position

		foreignRobotSprite.position = foreignRobotRelativePosition
		foreignRobotCollisionShape.position = foreignRobotRelativePosition

		get_tree().get_current_scene().remove_child(area.get_parent())

		add_child(foreignRobotSprite)
		add_child(foreignRobotCollisionShape)
