extends KinematicBody2D

var direction_to_go = null
var rng = RandomNumberGenerator.new()
var camera #set by spawner 

func _ready():
	pass

func idle():
	pass # do nothing XD

func choose_direction():
	var move_distance = camera.get_viewport().size.length()
	rng.randomize()
	var signs = [1, -1]
	var rand_sign = Vector2(signs[rng.randi_range(0,1)], signs[rng.randi_range(0,1)])
	rng.randomize()
	var delta = Vector2(rng.randf_range(1,2), rng.randf_range(1,2))
	direction_to_go = camera.get_camera_position() + move_distance * delta * rand_sign

func go():
	move_and_collide((direction_to_go - position).normalized())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
