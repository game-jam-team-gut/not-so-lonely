extends RigidBody2D

var direction_to_go = null
var rng = RandomNumberGenerator.new()
var camera #set by spawner 
var movement_force_max = 12
var movement_force_min = 5

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
	rng.randomize()
	var strength = (direction_to_go - position).normalized() * rng.randi_range(movement_force_min,movement_force_max)
	add_force(Vector2.ZERO, strength * 2)
	add_central_force(strength)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
