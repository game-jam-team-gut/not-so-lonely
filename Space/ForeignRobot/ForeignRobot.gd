extends RigidBody2D

signal robot_sticked(pos)

var position_to_go = null

var rng = RandomNumberGenerator.new()
var state_time #constant for the whole lifetime

var movement_force_max = 12
var movement_force_min = 5

var camera #set by spawner 

var player # set by spawner
var connected_through
var neighbours = []
var attached = false

func _ready():
	rng.randomize()
	state_time = rng.randi_range(500, 10000)
	get_node("Area2D").connect("area_entered", self, "sticking_field_area_entered")
	self.connect("robot_sticked", player, "robot_sticked_to_another")

func idle():
	pass # do nothing XD

func attach(to):
	get_node("Area2D").remove_from_group("ForeignRobots")
	custom_integrator = true
	attached = true

func detach():
	neighbours.clear()
	connected_through = null
	attached = false
	custom_integrator = false
	get_node("Area2D").add_to_group("ForeignRobots")

func destroy():
	for neighbour in neighbours:
		if (neighbour != null and is_instance_valid(neighbour)):
			neighbour.neighbour_destroyed(self)
	queue_free()

func neighbour_destroyed(neighbour):
	if (neighbour == connected_through):
		detach()

func choose_direction():
	rng.randomize()
	match rng.randi_range(1,2):
		1:
			var move_distance = camera.get_viewport().size.length()
			rng.randomize()
			var signs = [1, -1]
			var rand_sign = Vector2(signs[rng.randi_range(0,1)], signs[rng.randi_range(0,1)])
			rng.randomize()
			var delta = Vector2(rng.randf_range(1,2), rng.randf_range(1,2))
			position_to_go = camera.global_position + move_distance * delta * rand_sign
		2:
			if camera.global_position.distance_to(position) < camera.get_viewport().size.length() / 3:
				position_to_go = position + (position - camera.global_position)
			else:
				position_to_go = camera.global_position + Vector2(rng.randf_range(-100, 100), rng.randf_range(-100, 100))

func go():
	rng.randomize()
	var strength = (position_to_go - position).normalized() * rng.randi_range(movement_force_min, movement_force_max)
	add_force(Vector2.ZERO, strength)
	add_central_force(strength)

func sticking_field_area_entered(area):
	if (attached):
		if area.is_in_group("ForeignRobots"):
			var foreignRobot = area.get_parent()
			var foreignRobotRelativePosition = foreignRobot.position - player.position
			var foreignRobotGlobalPosition = foreignRobot.get_global_position()
			foreignRobot.connected_through = self
			foreignRobot.neighbours.append(self)
			neighbours.append(foreignRobot)
			foreignRobot.attach(self)
			
			foreignRobot.get_parent().remove_child(foreignRobot)
			var joint = PinJoint2D.new()
			player.add_child(joint)
			joint.add_child(foreignRobot)
			joint.node_a = player.get_path()
			joint.node_b = foreignRobot.get_path()
			foreignRobot.set_global_position(foreignRobotGlobalPosition)
			
			emit_signal("robot_sticked", foreignRobotRelativePosition)
