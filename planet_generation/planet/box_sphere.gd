class_name BoxSphere
extends Node

static func create_plane(subdiv: int, index: int, direction: Vector3, center: Vector3) -> Array:
	var surface_array: Array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var positions := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	
	direction = direction.normalized()
	var binormal := Vector3(direction.z, direction.x, direction.y) / subdiv
	var tangent := binormal.rotated(direction, PI / 2.0)
	var offset := -subdiv * (binormal + tangent) / 2.0 + center
	
	positions.resize((subdiv + 1) * (subdiv + 1))
	normals.resize((subdiv + 1) * (subdiv + 1))
	normals.fill(direction)
	indices.resize(subdiv * subdiv * 6)
	
	var i := 0
	for x: int in subdiv + 1:
		for y: int in subdiv + 1:
			var vertex_offset := binormal * x + tangent * y + offset
			positions[i] = vertex_offset
			i += 1
	
	i = 0
	for x: int in subdiv:
		for y: int in subdiv:
			var index_offset := x * (subdiv + 1) + y + index
			
			indices[i + 0] = index_offset
			indices[i + 1] = index_offset + 1
			indices[i + 2] = index_offset + subdiv + 2
			indices[i + 3] = index_offset
			indices[i + 4] = index_offset + subdiv + 2
			indices[i + 5] = index_offset + subdiv + 1
			i += 6
			
			#indices.append_array([
				#index_offset, index_offset + 1, index_offset + subdiv + 2,
				#index_offset, index_offset + subdiv + 2, index_offset + subdiv + 1
			#])
	surface_array[Mesh.ARRAY_VERTEX] = positions
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	
	return surface_array

static func create_cube(subdiv: int) -> Array:
	var surface_array: Array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var positions := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	
	const directions: PackedVector3Array = [
		Vector3.UP, Vector3.DOWN, Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK
	]
	
	for i: int in directions.size():
		var index := positions.size()
		var plane := create_plane(subdiv, index, directions[i], directions[i] / 2.0)
		positions.append_array(plane[Mesh.ARRAY_VERTEX])
		normals.append_array(plane[Mesh.ARRAY_NORMAL])
		indices.append_array(plane[Mesh.ARRAY_INDEX])
	
	surface_array[Mesh.ARRAY_VERTEX] = positions
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	
	return surface_array

static func create_sphere(subdiv: int, scale: float) -> Array:
	var surface_array := create_cube(subdiv)
	
	for i: int in surface_array[Mesh.ARRAY_VERTEX].size():
		var vertex: Vector3 = surface_array[Mesh.ARRAY_VERTEX][i]
		surface_array[Mesh.ARRAY_VERTEX][i] = (vertex.normalized() / 2.0) * scale
		surface_array[Mesh.ARRAY_NORMAL][i] = vertex.normalized()
	
	return surface_array
