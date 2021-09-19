extends StaticBody2D

signal robot_sticked(pos)

var player # set by barney or another sticked robot
var connected_through
var neighbours = []

func _ready():
	self.connect("robot_sticked", player, "robot_sticked_to_another")

func destroy():
	for neighbour in neighbours:
		if (neighbour != null and is_instance_valid(neighbour)):
			neighbour.neighbour_destroyed(self)
	queue_free()

func detach():
	pass

func neighbour_destroyed(neighbour):
	if (neighbour == connected_through):
		destroy() #change to detach() later, when detach logic completed

func _on_StickingField_area_entered(area):
	pass
