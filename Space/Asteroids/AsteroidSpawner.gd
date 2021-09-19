extends Node

var MAX_ASTEROID_COUNT = 200
var START_ASTEROIDS_COUNT = 10
var MAX_ASTEROID_DISTANCE = 20000

onready var asteroids = [preload("res://Space/Asteroids/Asteroid1.tscn"), preload("res://Space/Asteroids/Asteroid2.tscn"), preload("res://Space/Asteroids/Asteroid3.tscn")]
onready var barney = get_node("../Barney")
onready var camera = barney.get_node("Camera2D")

onready var spawn_distance = camera.get_viewport().size.length()
var rng = RandomNumberGenerator.new()

var current_asteroids = []

func _ready():
	yield(get_tree().create_timer(.1), "timeout")
	generate_starting_asteroids()

func choose_point_to_go():
	rng.randomize()
	match rng.randi_range(1,2):
		1:
			var move_distance = camera.get_viewport().size.length()
			rng.randomize()
			var signs = [1, -1]
			var rand_sign = Vector2(signs[rng.randi_range(0,1)], signs[rng.randi_range(0,1)])
			rng.randomize()
			var delta = Vector2(rng.randf_range(1,2), rng.randf_range(1,2))
			return camera.global_position + move_distance * delta * rand_sign
		2:
			return camera.global_position + Vector2(rng.randf_range(-100, 100), rng.randf_range(-100, 100))

func spawn():
	rng.randomize()
	var asteroid_instance = asteroids[rand_range(0, len(asteroids))].instance()
	get_parent().add_child(asteroid_instance)
	rng.randomize()
	var signs = [1, -1]
	var rand_sign = Vector2(signs[rng.randi_range(0,1)], signs[rng.randi_range(0,1)])
	rng.randomize()
	var delta = Vector2(rng.randf_range(1,2), rng.randf_range(1,2))
	asteroid_instance.position = camera.get_camera_position() + spawn_distance * delta * rand_sign
	current_asteroids.append(asteroid_instance)
	rng.randomize()
	var initial_force = rng.randf_range(0, 100)
	rng.randomize()
	var initial_aim = choose_point_to_go()
	asteroid_instance.set_initial_force((initial_aim - asteroid_instance.position).normalized() * initial_force)

func generate_starting_asteroids():
	while len(current_asteroids) < START_ASTEROIDS_COUNT:
		spawn()

func _on_SpawnTimer_timeout():
		spawn_distance = camera.get_viewport().size.length()
		spawn()
		for asteroid in current_asteroids:
			if barney.position.distance_to(asteroid.position) > MAX_ASTEROID_DISTANCE:
				asteroid.destroy()
