extends KinematicBody2D

var direction_to_go = null
var xd = "XDF"

func _ready():
	pass

func idle():
	pass # do nothing XD

func choose_direction():
	#get player position
	#get zone in which we can move
	#choose target
	#for now leave this shit
	direction_to_go = Vector2(rand_range(100, 400), rand_range(100,400))

func go():
	move_and_collide((direction_to_go - position).normalized())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
