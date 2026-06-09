extends Node2D
class_name Moveable

var tile := Vector2i.ZERO
var tween: Tween

func _enter_tree() -> void:
	Level.moveables.append(self)

func _exit_tree() -> void:
	Level.moveables.erase(self)

func _ready() -> void:
	tile = position / 16
	position = tile * 16.0 + Vector2(8.0, 8.0)

func can_move(direction: Vector2i) -> bool:
	if Level.is_tile_wall(tile + direction):
		return false
	var moveable := Level.get_moveable_at_tile(tile + direction)
	if moveable:
		return moveable.can_move(direction)
	return true

func move(direction: Vector2i) -> void:
	var moveable := Level.get_moveable_at_tile(tile + direction)
	if moveable:
		moveable.move(direction)
	slide(direction)
	
	Level.add_move_to_turn(self, direction)

func slide(direction: Vector2i) -> void:
	position = tile * 16.0 + Vector2(8.0, 8.0)
	tile += direction
	
	var target := tile * 16.0 + Vector2(8.0, 8.0)
	tween = create_tween()
	tween.tween_property(self, "position", target, 0.08)
