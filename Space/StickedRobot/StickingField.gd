extends Area2D


#to remove later, debug
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if (event.is_pressed() and event.button_index == BUTTON_MIDDLE):
			get_parent().destroy()
