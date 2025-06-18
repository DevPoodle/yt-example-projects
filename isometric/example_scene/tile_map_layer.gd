extends TileMapLayer

func _ready() -> void:
	var filled_tiles := get_used_cells()
	for filled_tile: Vector2i in filled_tiles:
		var neighboring_tiles := get_surrounding_cells(filled_tile)
		for neighbor: Vector2i in neighboring_tiles:
			if get_cell_source_id(neighbor) == -1:
				set_cell(neighbor, 0, Vector2i.ZERO)
