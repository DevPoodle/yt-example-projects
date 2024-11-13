@tool
extends MeshInstance3D

@export var reload := false :
	set(new_reload):
		reload = false
		regenerate_mesh()

@export_range(1, 32) var subdivisions := 1 :
	set(new_subdivisions):
		subdivisions = new_subdivisions
		regenerate_mesh()

var array_mesh: ArrayMesh

func _ready() -> void:
	regenerate_mesh()

func regenerate_mesh() -> void:
	if !array_mesh:
		array_mesh = ArrayMesh.new()
		mesh = array_mesh
	array_mesh.clear_surfaces()
	var surface_array := create_sphere(subdivisions)
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	make_wire() # Just for the purposes of debugging, probably should be turned off in a real project

func make_wire():
	var material := array_mesh.surface_get_material(0)
	var array := array_mesh.surface_get_arrays(0)
	array_mesh.clear_surfaces()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, array)
	array_mesh.surface_set_material(0, material)

func create_plane(subdiv: int, index: int, direction: Vector3, center: Vector3) -> Array:
	var surface_array: Array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var positions := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	
	direction = direction.normalized()
	var binormal := Vector3(direction.z, direction.x, direction.y) / subdiv
	var tangent := binormal.rotated(direction, PI / 2.0)
	var offset := -subdiv * (binormal + tangent) / 2.0 + center
	
	for x: int in subdiv:
		for y: int in subdiv:
			var vertex_offset := binormal * x + tangent * y + offset
			var index_offset := 4 * (x * subdiv + y) + index
			
			positions.append_array([
				vertex_offset,
				vertex_offset + tangent,
				vertex_offset + tangent + binormal,
				vertex_offset + binormal
			])
			
			normals.append_array([
				direction, direction, direction, direction
			])
			
			indices.append_array([
				index_offset, index_offset + 1, index_offset + 2,
				index_offset, index_offset + 2, index_offset + 3
			])
	surface_array[Mesh.ARRAY_VERTEX] = positions
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	
	return surface_array

func create_cube(subdiv: int) -> Array:
	var surface_array: Array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var positions := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	
	const directions: PackedVector3Array = [
		Vector3.UP, Vector3.DOWN, Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK
	]
	
	for i: int in directions.size():
		var index := 4 * i * subdiv * subdiv
		var plane := create_plane(subdiv, index, directions[i], directions[i] / 2.0)
		positions.append_array(plane[Mesh.ARRAY_VERTEX])
		normals.append_array(plane[Mesh.ARRAY_NORMAL])
		indices.append_array(plane[Mesh.ARRAY_INDEX])
	
	surface_array[Mesh.ARRAY_VERTEX] = positions
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	
	return surface_array

func create_sphere(subdiv: int) -> Array:
	var surface_array := create_cube(subdiv)
	
	for i: int in surface_array[Mesh.ARRAY_VERTEX].size():
		var vertex: Vector3 = surface_array[Mesh.ARRAY_VERTEX][i]
		surface_array[Mesh.ARRAY_VERTEX][i] = vertex.normalized() / 2.0
		surface_array[Mesh.ARRAY_NORMAL][i] = vertex.normalized()
	
	return surface_array
