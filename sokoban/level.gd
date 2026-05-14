extends Node

var tilemap: TileMapLayer
var moveables: Array[Moveable]

func _ready() -> void:
	get_tree().scene_changed.connect(level_changed)
	level_changed()

func level_changed() -> void:
	tilemap = get_tree().get_first_node_in_group("LevelTileMap")

func is_tile_wall(tile: Vector2i) -> bool:
	return tilemap != null and tilemap.get_cell_source_id(tile) == 0

func get_moveable_at_tile(tile: Vector2i) -> Moveable:
	for node: Moveable in moveables:
		if node.tile == tile:
			return node
	return null
