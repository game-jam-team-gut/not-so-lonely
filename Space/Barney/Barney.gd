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

func update_magnetic_field_size():
	collisionShape2D.shape.extents.x += 0
	collisionShape2D.position.x = 0

func get_input():
	check_movement()

func _physics_process(_delta):
	update_magnetic_field_size()
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
		var foreignRobotRelativePosition = foreignRobot.position - position
		var foreignRobotGlobalPosition = foreignRobot.get_global_position()
		foreignRobot.attach(self)
		foreignRobot.get_parent().remove_child(foreignRobot)
		var joint = PinJoint2D.new()
		self.add_child(joint)
		joint.add_child(foreignRobot)
		joint.node_a = self.get_path()
		joint.node_b = foreignRobot.get_path()
		foreignRobot.set_global_position(foreignRobotGlobalPosition)
		
		emit_signal("robot_sticked", foreignRobotRelativePosition)

func robot_sticked_to_another(pos):
	emit_signal("robot_sticked", pos)
