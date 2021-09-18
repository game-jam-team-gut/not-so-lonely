extends Sprite

func _physics_process(_delta):
	look_at(get_parent().targetPosition)
