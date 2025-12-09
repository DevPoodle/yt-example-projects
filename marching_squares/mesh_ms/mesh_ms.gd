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
	var mesh := ArrayMesh.new()
	$MeshInstance2D.mesh = mesh
	
	var surface_array := []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	surface_array[Mesh.ARRAY_VERTEX] = PackedVector2Array()
	surface_array[Mesh.ARRAY_INDEX] = PackedInt32Array()
	
	for x: int in range(-32, 32):
		for y: int in range(-32, 32):
			var center := Vector2(x + 0.5, y + 0.5) * 64.0
			var value := 0
			for i: int in CORNERS.size():
				var corner := center + CORNERS[i] * 32.0
				value += int(sample(corner) > 0.0) << i
			add_tile(surface_array, center, value)
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)

func add_tile(surface_array: Array, center: Vector2, tile_index: int) -> void:
	var vertices := MSMeshes.VERTEX_ARRAYS[tile_index].duplicate()
	var indices := MSMeshes.INDEX_ARRAYS[tile_index].duplicate()
	var total_vertices: int = surface_array[Mesh.ARRAY_VERTEX].size()
	
	for i: int in vertices.size():
		var vertex := vertices[i]
		var is_edge := absf(vertex.x) + absf(vertex.y) == 1.0
		var direction := Vector2.UP if vertex.x != 0.0 else Vector2.RIGHT
		
		vertex = vertex * 32.0 + center
		if is_edge:
			var corner_1 := vertex + direction * 32.0
			var corner_2 := vertex - direction * 32.0
			var value_1 := sample(corner_1)
			var value_2 := sample(corner_2)
			
			var weight := (value_1 + value_2) / (value_1 - value_2) / 2.0 + 0.5
			vertex = corner_1.lerp(corner_2, weight)
		vertices[i] = vertex
	
	for i: int in indices.size():
		indices[i] += total_vertices
	
	surface_array[Mesh.ARRAY_VERTEX].append_array(vertices)
	surface_array[Mesh.ARRAY_INDEX].append_array(indices)
