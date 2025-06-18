extends CharacterBody2D

const max_speed := 40.0
const min_speed := 8.0
const time_to_max_speed := 0.1
const time_to_stop := 0.05
const time_to_turn := 0.05

const acceleration := max_speed / time_to_max_speed
const friction := max_speed / time_to_stop
const turn_speed := max_speed / time_to_turn

var dir_input := Vector2.ZERO

func _physics_process(delta: float) -> void:
	dir_input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if dir_input != Vector2.ZERO:
		if !dir_input.normalized().is_equal_approx(velocity.normalized()):
			velocity += dir_input * turn_speed * delta
		else:
			velocity += dir_input * acceleration * delta
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
	elif velocity != Vector2.ZERO:
		velocity -= velocity.normalized() * friction * delta 
		if velocity.length() < min_speed:
			velocity = Vector2.ZERO
	move_and_slide()
