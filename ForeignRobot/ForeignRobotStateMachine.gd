extends "res://Scripts/StateMachine.gd"

var label: Label
var change_to_next_state = false
var state_start = 0

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
	var state_duration = (OS.get_ticks_msec() - state_start) #msec
	match current_state:
		states.idle:
			return states.choose_direction
		states.choose_direction:
			return states.go
		states.go:
			if ((parent.position_to_go - parent.position).length() < 1) || state_duration > parent.state_time:
				return states.idle
	return null;

func _enter_state(new_state, old_state):
	state_start = OS.get_ticks_msec()
	match new_state:
		states.go:
			parent.go()

func _exit_state(old_state, new_state):
	pass
