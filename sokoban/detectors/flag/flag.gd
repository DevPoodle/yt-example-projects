extends Detector
class_name Flag

func _on_entered(node: Moveable) -> void:
	if node is Player:
		get_tree().reload_current_scene()
