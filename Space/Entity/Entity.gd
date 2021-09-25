extends RigidBody2D

var position_to_go = null

var rng = RandomNumberGenerator.new()
var state_time #constant for the whole lifetime

var camera #set by spawner 

var movement_force_max = 12
var movement_force_min = 5

func _ready():
	rng.randomize()
	state_time = rng.randi_range(500, 10000)

func destroy():
	#particles
	queue_free()

func idle():
	pass # do nothing XD

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
