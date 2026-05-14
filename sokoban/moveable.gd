extends Node2D
class_name Moveable

var tile := Vector2i.ZERO
var tween: Tween

func _ready() -> void:
	tile = position / 16
	position = tile * 16.0 + Vector2(8.0, 8.0)

func can_move(direction: Vector2i) -> bool:
	return true

func move(direction: Vector2i) -> void:
	slide(direction)

func slide(direction: Vector2i) -> void:
	position = tile * 16.0 + Vector2(8.0, 8.0)
	tile += direction
	
	var target := tile * 16.0 + Vector2(8.0, 8.0)
	tween = create_tween()
	tween.tween_property(self, "position", target, 0.08)
