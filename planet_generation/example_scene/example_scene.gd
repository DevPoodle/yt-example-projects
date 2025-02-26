extends Node3D

func _process(delta: float) -> void:
	$Planet.rotate(Vector3(0.0, 1.0, 0.2).normalized(), delta * 0.2)
