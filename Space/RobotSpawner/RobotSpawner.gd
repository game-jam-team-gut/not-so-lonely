extends Node

onready var robots = [preload("res://Space/ForeignRobot1.tscn"), preload("res://Space/ForeignRobot2.tscn"), preload("res://Space/ForeignRobot3.tscn"), preload("res://Space/ForeignRobot4.tscn"), preload("res://Space/ForeignRobot5.tscn"), preload("res://Space/ForeignRobot6.tscn"), preload("res://Space/ForeignRobot7.tscn"), preload("res://Space/ForeignRobot8.tscn")]
onready var barney = get_node("../Barney")
onready var camera = barney.get_node("Camera2D")

var current_robots = []
var current_stage
var start_robot_count = 20
onready var spawn_distance = camera.get_viewport().size.length()
var rng = RandomNumberGenerator.new()

func _ready():
	yield(get_tree().create_timer(.1), "timeout")
	generate_starting_robots()

func generate_starting_robots():
	while len(current_robots) < start_robot_count:
		rng.randomize()
		var robot_instance = robots[rand_range(0, len(robots))].instance()
		get_parent().add_child(robot_instance)
		rng.randomize()
		var signs = [1, -1]
		var rand_sign = Vector2(signs[rng.randi_range(0,1)], signs[rng.randi_range(0,1)])
		rng.randomize()
		var delta = Vector2(rng.randf_range(0.1,1), rng.randf_range(0.1,1))
		robot_instance.position = camera.get_camera_position() + spawn_distance * delta * rand_sign
		
		current_robots.append(robot_instance)
		robot_instance.camera = camera

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnTimer_timeout():
		spawn_distance = camera.get_viewport().size.length()
		rng.randomize()
		var robot_instance = robots[rand_range(0, len(robots))].instance()
		get_parent().add_child(robot_instance)
		rng.randomize()
		var signs = [1, -1]
		var rand_sign = Vector2(signs[rng.randi_range(0,1)], signs[rng.randi_range(0,1)])
		rng.randomize()
		var delta = Vector2(rng.randf_range(1,2), rng.randf_range(1,2))
		robot_instance.position = camera.get_camera_position() + spawn_distance * delta * rand_sign
		current_robots.append(robot_instance)
		robot_instance.camera = camera
