extends Moveable

func _input(event: InputEvent) -> void:
	if !event.is_pressed():
		return
	var direction := Vector2i.ZERO
	match event.as_text():
		"Up":
			direction = Vector2i.UP
		"Down":
			direction = Vector2i.DOWN
		"Left":
			direction = Vector2i.LEFT
		"Right":
			direction = Vector2i.RIGHT
		"Z":
			Level.undo_last_move()
			return
		_:
			return
	if can_move(direction):
		Level.past_turns.append([])
		move(direction)
