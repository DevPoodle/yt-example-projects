extends Node
class_name MSMeshes

static var VERTEX_ARRAYS: Array[PackedVector2Array] = [
	[],
	[Vector2(-1,  0), Vector2(-1,  1), Vector2( 0,  1)],
	[Vector2( 1,  0), Vector2( 0,  1), Vector2( 1,  1)],
	[Vector2(-1,  0), Vector2(-1,  1), Vector2( 1,  1), Vector2( 1,  0)],
	[Vector2( 1,  0), Vector2( 1, -1), Vector2( 0, -1)],
	[Vector2( 1,  0), Vector2( 1, -1), Vector2( 0, -1), Vector2(-1,  0), Vector2(-1, 1), Vector2(0, 1)],
	[Vector2( 0, -1), Vector2( 0,  1), Vector2( 1,  1), Vector2( 1, -1)],
	[Vector2( 1,  1), Vector2( 1, -1), Vector2( 0, -1), Vector2(-1,  0), Vector2(-1, 1)],
	[Vector2( 0, -1), Vector2(-1, -1), Vector2(-1,  0)],
	[Vector2( 0, -1), Vector2(-1, -1), Vector2(-1,  1), Vector2( 0,  1)],
	[Vector2( 1,  0), Vector2( 0, -1), Vector2(-1, -1), Vector2(-1,  0), Vector2( 0, 1), Vector2(1, 1)],
	[Vector2( 1,  0), Vector2( 0, -1), Vector2(-1, -1), Vector2(-1,  1), Vector2( 1, 1)],
	[Vector2(-1, -1), Vector2(-1,  0), Vector2( 1,  0), Vector2( 1, -1)],
	[Vector2( 1,  0), Vector2( 1, -1), Vector2(-1, -1), Vector2(-1,  1), Vector2( 0, 1)],
	[Vector2( 1,  1), Vector2( 1, -1), Vector2(-1, -1), Vector2(-1,  0), Vector2( 0, 1)],
	[Vector2(-1, -1), Vector2(-1,  1), Vector2( 1,  1), Vector2( 1, -1)],
]

static var INDEX_ARRAYS: Array[PackedInt32Array] = [
	[],
	[0, 1, 2],
	[0, 1, 2],
	[0, 1, 2, 0, 2, 3],
	[0, 1, 2],
	[0, 1, 2, 0, 2, 3, 0, 3, 4, 0, 4, 5],
	[0, 1, 2, 0, 2, 3],
	[0, 1, 2, 0, 2, 3, 0, 3, 4],
	[0, 1, 2],
	[0, 1, 2, 0, 2, 3],
	[0, 1, 2, 0, 2, 3, 0, 3, 4, 0, 4, 5],
	[0, 1, 2, 0, 2, 3, 0, 3, 4],
	[0, 1, 2, 0, 2, 3],
	[0, 1, 2, 0, 2, 3, 0, 3, 4],
	[0, 1, 2, 0, 2, 3, 0, 3, 4],
	[0, 1, 2, 0, 2, 3],
]
