extends Node

func _ready():
	get_node("AudioStreamPlayer").play()

func _on_AudioStreamPlayer_finished():
	get_node("AudioStreamPlayer2").play()

func _on_AudioStreamPlayer2_finished():
	get_node("AudioStreamPlayer3").play()

func _on_AudioStreamPlayer3_finished():
	get_node("AudioStreamPlayer2").play()
