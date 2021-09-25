extends Node

onready var entities = [preload("res://Space/ForeignRobot1.tscn"), preload("res://Space/ForeignRobot2.tscn"), preload("res://Space/ForeignRobot3.tscn"),
	preload("res://Space/ForeignRobot4.tscn"), preload("res://Space/ForeignRobot5.tscn"), preload("res://Space/ForeignRobot6.tscn"),
	preload("res://Space/ForeignRobot7.tscn"), preload("res://Space/ForeignRobot8.tscn"), preload("res://Space/ForeignRobot9.tscn"),
	preload("res://Space/Asteroid1.tscn"), preload("res://Space/Asteroid2.tscn"), preload("res://Space/Asteroid3.tscn"),
	preload("res://Space/Asteroid1.tscn"), preload("res://Space/Asteroid2.tscn"), preload("res://Space/Asteroid3.tscn")]
onready var barney = get_node("../Barney")
onready var camera = barney.get_node("Camera2D")

var current_entities = []
var current_stage
var start_entity_count = 20
onready var spawn_distance = camera.get_viewport().size.length()
var rng = RandomNumberGenerator.new()

func _ready():
	yield(get_tree().create_timer(.1), "timeout")
	generate_starting_entities()

func generate_starting_entities():
	while len(current_entities) < start_entity_count:
		rng.randomize()
		var entity_instance = entities[rand_range(0, len(entities))].instance()
		get_parent().add_child(entity_instance)
		rng.randomize()
		var signs = [1, -1]
		var rand_sign = Vector2(signs[rng.randi_range(0,1)], signs[rng.randi_range(0,1)])
		rng.randomize()
		var delta = Vector2(rng.randf_range(0.1,1), rng.randf_range(0.1,1))
		entity_instance.position = camera.get_camera_position() + spawn_distance * delta * rand_sign
		
		current_entities.append(entity_instance)
		entity_instance.camera = camera

func _on_SpawnTimer_timeout():
	spawn_distance = camera.get_viewport().size.length()
	rng.randomize()
	var entity_instance = entities[rand_range(0, len(entities))].instance()
	get_parent().add_child(entity_instance)
	rng.randomize()
	var signs = [1, -1]
	var rand_sign = Vector2(signs[rng.randi_range(0,1)], signs[rng.randi_range(0,1)])
	rng.randomize()
	var delta = Vector2(rng.randf_range(1,2), rng.randf_range(1,2))
	entity_instance.position = camera.get_camera_position() + spawn_distance * delta * rand_sign
	current_entities.append(entity_instance)
	entity_instance.camera = camera
