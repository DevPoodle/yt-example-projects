extends Node2D

const CORNERS: PackedVector2Array = [
	Vector2(-1,  1),
	Vector2( 1,  1),
	Vector2( 1, -1),
	Vector2(-1, -1),
]

@export var noise: FastNoiseLite

func sample(input: Vector2) -> float:
	return noise.get_noise_2dv(input)

func _ready() -> void:
	var tilemap: TileMapLayer = $TileMapLayer
	tilemap.clear()
	
	for x: int in range(-32, 32):
		for y: int in range(-32, 32):
			var center := Vector2(x + 0.5, y + 0.5) * 64.0
			var value := 0
			for i: int in CORNERS.size():
				var corner := center + CORNERS[i] * 32.0
				value += int(sample(corner) > 0.0) << i
			tilemap.set_cell(Vector2i(x, y), 0, Vector2i(value % 4, value / 4))
