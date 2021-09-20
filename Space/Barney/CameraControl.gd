extends Camera2D

onready var zoom_tween = get_node("Tween")
var zoom_duration = 0.8
var zoom_out_scale = 1.5
var zoom_out_treshold = 0.85
var viewport_size_quarter

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
	get_parent().updateMagneticFieldSize()

func _on_Barney_robot_sticked(pos):
	viewport_size_quarter = get_viewport().size * 0.5 * zoom
	var offset = viewport_size_quarter.x * (1 - zoom_out_treshold)
	viewport_size_quarter -= Vector2(offset, offset)
	
	var top_left = -viewport_size_quarter
	var bottom_right = viewport_size_quarter
	var bottom_left = Vector2(-viewport_size_quarter.x, viewport_size_quarter.y)
	var top_right = Vector2(viewport_size_quarter.x, -viewport_size_quarter.y)
	
	if (not (pos.x > top_left.x && pos.x < bottom_right.x &&
		pos.y > top_left.y && pos.y < bottom_right.y)):
		zoom_out()
