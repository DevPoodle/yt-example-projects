extends Node2D

@export_node_path("CharacterBody3D") var player

var head: Node3D
var prev_rotation: Vector2

func _ready() -> void:
	head = get_node(player).HEAD
	prev_rotation = Vector2(head.rotation.y, head.rotation.x)

func _physics_process(delta: float) -> void:
	var current_rotation := Vector2(head.rotation.y, head.rotation.x)
	var dist := current_rotation - prev_rotation
	$Camera2D.offset -= dist * delta * 1600.0
	prev_rotation = current_rotation
	
	$Camera2D.offset = lerp($Camera2D.offset, Vector2.ZERO, 1.0 - pow(0.03, delta))
