extends Camera2D


onready var zoom_tween = get_node("Tween")
var zoom_duration = 0.8
var zoom_out_scale = 1.5
var zoom_out_treshold = 0.75


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func zoom_out():
	zoom_tween.interpolate_property(
		self,
		"zoom",
		zoom,
		zoom * zoom_out_scale,
		zoom_duration,
		zoom_tween.TRANS_SINE,
		# Easing out means we start fast and slow down as we reach the target value.
		zoom_tween.EASE_OUT
	)
	zoom_tween.start()


func _on_Barney_robot_sticked(global_pos):
	var viewport_size = get_viewport().size * 0.5 * zoom * zoom_out_treshold
	var relative_pos = global_pos - global_position
	print("---")
	print(relative_pos)
	print(viewport_size)
	if (abs(relative_pos.x) > viewport_size.x || abs(relative_pos.y) > viewport_size.y):
		zoom_out()
