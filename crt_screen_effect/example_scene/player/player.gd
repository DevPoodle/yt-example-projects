extends CharacterBody2D

const max_speed := 120.0
const min_speed := 10.0
const acceleration := 400.0
const friction := 300.0

const jump_speed := 320.0
const gravity := 1200.0

func _physics_process(delta: float) -> void:
	var input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input.x != 0.0:
		velocity.x += input.x * acceleration * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)
		$Penguin.flip_h = signf(input.x) == -1.0
		if is_on_floor():
			$AnimationPlayer.play("walk")
	elif velocity.x != 0.0:
		if is_on_floor():
			$AnimationPlayer.play("idle")
		velocity.x -= signf(velocity.x) * friction * delta
		if absf(velocity.x) < min_speed:
			velocity.x = 0.0
	elif is_on_floor():
		$AnimationPlayer.play("idle")
	
	velocity.y += gravity * delta
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = -jump_speed
	if !is_on_floor():
		$AnimationPlayer.play("jump")
	
	move_and_slide()
	
	if position.y > 120.0:
		get_tree().reload_current_scene()
