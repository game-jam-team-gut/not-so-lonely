extends "res://Scripts/StateMachine.gd"

var label: Label
var change_to_next_state = false

func _ready():
	label = get_node("../Label")
	add_state("idle")
	add_state("choose_direction")
	add_state("go")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	label.text = states.keys()[current_state]
	match current_state:
		states.idle:
			parent.idle()
		states.choose_direction:
			parent.choose_direction()

func _get_transition(delta):
	match current_state:
		states.idle:
			return states.choose_direction
		states.choose_direction:
			return states.go
		states.go:
			if ((parent.direction_to_go - parent.position).length() < 1):
				return states.idle
	return null;

func _enter_state(new_state, old_state):
	match new_state:
		states.go:
			parent.go()

func _exit_state(old_state, new_state):
	pass
