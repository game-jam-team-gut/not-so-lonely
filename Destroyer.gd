extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton:
		if (event.is_pressed() and event.button_index == BUTTON_MIDDLE):
			var mousePos = get_global_mouse_position()
			var space = get_world_2d().direct_space_state
			var collision_objects = space.intersect_point(mousePos, 1)
			if collision_objects:
				collision_objects[0].collider.destroy()
