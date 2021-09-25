extends Node

onready var foreignRobots = [preload("res://Space/ForeignRobot1.tscn"), preload("res://Space/ForeignRobot2.tscn"), preload("res://Space/ForeignRobot3.tscn"),
	preload("res://Space/ForeignRobot4.tscn"), preload("res://Space/ForeignRobot5.tscn"), preload("res://Space/ForeignRobot6.tscn"),
	preload("res://Space/ForeignRobot7.tscn"), preload("res://Space/ForeignRobot8.tscn"), preload("res://Space/ForeignRobot9.tscn")]
onready var asteroids = [preload("res://Space/Asteroid1.tscn"), preload("res://Space/Asteroid2.tscn"), preload("res://Space/Asteroid3.tscn")]
onready var barney = get_node("../Barney")
onready var camera = barney.get_node("Camera2D")

var currentEntities = []
var currentStage
var startEntityCount = 20
onready var spawnDistance = camera.get_viewport().size.length()
var rng = RandomNumberGenerator.new()

func _ready():
	yield(get_tree().create_timer(.1), "timeout")
	generate_starting_entities()

func randomize_entity_type():
	rng.randomize()
	var entityType = rng.randi_range(0, 1)
	if entityType == 0:
		return foreignRobots[rand_range(0, len(foreignRobots))]
	elif entityType == 1:
		return asteroids[rand_range(0, len(asteroids))]

func create_entity(deltaRange):
	var entityInstance = randomize_entity_type().instance()
	get_parent().add_child(entityInstance)
	rng.randomize()
	var signs = [1, -1]
	var randSign = Vector2(signs[rng.randi_range(0,1)], signs[rng.randi_range(0,1)])
	var delta = Vector2(deltaRange, deltaRange)
	entityInstance.position = camera.get_camera_position() + spawnDistance * delta * randSign
	
	currentEntities.append(entityInstance)
	entityInstance.camera = camera

func generate_starting_entities():
	while len(currentEntities) < startEntityCount:
		rng.randomize()
		create_entity(rng.randf_range(0.1,1))

func _on_SpawnTimer_timeout():
	rng.randomize()
	create_entity(rng.randf_range(1,2))
