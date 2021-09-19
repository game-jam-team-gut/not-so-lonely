extends RigidBody2D


func _ready():
	#start rotation_speed
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var trq = rng.randf_range(-800, 800)
	set_applied_torque(trq)

func set_initial_force(force):
	set_applied_force(force) 

func destroy():
	queue_free()
