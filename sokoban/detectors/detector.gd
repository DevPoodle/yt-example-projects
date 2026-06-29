extends Node2D
class_name Detector

var tile := Vector2i.ZERO

signal entered(node: Moveable)
signal exited(node: Moveable)

func _ready() -> void:
	tile = position / 16
	position = tile * 16.0 + Vector2(8.0, 8.0)
	z_index -= 1

func _enter_tree() -> void:
	Level.detectors.append(self)

func _exit_tree() -> void:
	Level.detectors.erase(self)
