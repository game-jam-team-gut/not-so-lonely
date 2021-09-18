extends KinematicBody2D

export (int) var speed = 200

var targetPosition = Vector2()
var velocity = Vector2()

func get_input():
	if Input.is_action_pressed("m1"):
		targetPosition = get_global_mouse_position()
	else:
		targetPosition = position

func _physics_process(_delta):
	get_input()
	velocity = position.direction_to(targetPosition) * speed
	look_at(targetPosition)
	if position.distance_to(targetPosition) > 5:
		velocity = move_and_slide(velocity)
