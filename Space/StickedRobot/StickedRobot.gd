extends StaticBody2D

signal robot_sticked(global_pos)

func _on_StickingField_area_entered(area):
	if area.is_in_group("ForeignRobots"):
		var foreignRobot = area.get_parent()
		var foreignRobotRelativePosition = foreignRobot.position - get_parent().position
		var foreignRobotRotation = foreignRobot.rotation
		
		var stickedRobot = self.duplicate()
		var stickedRobotSprite = stickedRobot.get_node("sticked_robot")
		var stickedRobotCollisionShape2D = stickedRobot.get_node("StickingField/CollisionShape2D")
		
		stickedRobotSprite.position = foreignRobotRelativePosition
		stickedRobotCollisionShape2D.position = foreignRobotRelativePosition
		
		stickedRobotSprite.rotation = foreignRobotRotation
		stickedRobotCollisionShape2D.rotation = foreignRobotRotation
		
		get_tree().get_current_scene().remove_child(area.get_parent())
		
		get_parent().call_deferred("add_child", stickedRobot)
		
		emit_signal("robot_sticked", stickedRobot.position)
		
