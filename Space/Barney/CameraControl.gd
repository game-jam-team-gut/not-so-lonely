extends Camera2D

onready var zoom_tween = get_node("Tween")
var zoom_duration = 0.8
var zoom_out_scale = 1.5
var zoom_out_treshold = 0.85
onready var line = get_node("Line2D")# remove for final build
var debug_line = true

func _ready():
	line.set_visible(debug_line)

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
	
	yield(zoom_tween, "tween_completed") # remove for final build
	_on_Barney_robot_sticked(Vector2.ZERO) # remove for final build

func _on_Barney_robot_sticked(pos):
	var viewport_size_quarter = get_viewport().size * 0.5 * zoom
	var offset = viewport_size_quarter.x * (1 - zoom_out_treshold)
	viewport_size_quarter -= Vector2(offset, offset)
	
	var top_left = -viewport_size_quarter
	var bottom_right = viewport_size_quarter
	var bottom_left = Vector2(-viewport_size_quarter.x, viewport_size_quarter.y)
	var top_right = Vector2(viewport_size_quarter.x, -viewport_size_quarter.y)
	
	# remove for final build
	line.clear_points()
	line.add_point(top_left)
	line.add_point(bottom_left)
	line.add_point(bottom_right)
	line.add_point(top_right)
	line.add_point(top_left)
	#XD
	
	if (not (pos.x > top_left.x && pos.x < bottom_right.x &&
		pos.y > top_left.y && pos.y < bottom_right.y)):
		zoom_out()
