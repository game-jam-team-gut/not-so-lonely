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
	if area.is_in_group("ForeignRobots"):
		var foreignRobot = area.get_parent()
		var foreignRobotRelativePosition = foreignRobot.position - get_parent().position
		var foreignRobotRotation = foreignRobot.rotation
		var foreignRobotSprite = foreignRobot.get_node("Sprite").duplicate()
		var foreignRobotCollisionShape2D = foreignRobot.get_node("Area2D/CollisionShape2D").duplicate()
		
		foreignRobotSprite.position = foreignRobotRelativePosition
		foreignRobotCollisionShape2D.position =  foreignRobotRelativePosition
		
		foreignRobotSprite.rotation = foreignRobotRotation
		foreignRobotCollisionShape2D.rotation = foreignRobotRotation
		
		var stickedRobot = self.duplicate()
		stickedRobot.player = player
		stickedRobot.connected_through = self
		stickedRobot.neighbours.append(self)
		neighbours.append(stickedRobot)
		
		stickedRobot.add_child(foreignRobotSprite)
		stickedRobot.get_node("StickingField").call_deferred("add_child", foreignRobotCollisionShape2D)
		
		get_tree().get_current_scene().remove_child(area.get_parent())
		
		get_parent().call_deferred("add_child", stickedRobot)
		
		emit_signal("robot_sticked", foreignRobotRelativePosition)
	elif area.is_in_group("Asteroid"):
		area.get_parent().destroy()
		destroy()
