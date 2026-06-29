extends Detector

static var total_markers := 0
static var markers_set := 0

func _enter_tree() -> void:
	total_markers += 1
	super()

func _exit_tree() -> void:
	total_markers = 0
	markers_set = 0
	super()

func _on_entered(node: Moveable) -> void:
	if node is not Player:
		markers_set += 1
		node.modulate = Color("#99b")
		if markers_set == total_markers:
			get_tree().reload_current_scene()

func _on_exited(node: Moveable) -> void:
	if node is not Player:
		node.modulate = Color("#fff")
		markers_set -= 1
