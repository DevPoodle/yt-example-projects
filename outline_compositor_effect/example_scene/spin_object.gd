@tool
extends MeshInstance3D

const axis := Vector3(0.894427, 0, 0.447214)
const rot_speed := 0.5

func _process(delta: float) -> void:
	rotate_object_local(axis, delta)
