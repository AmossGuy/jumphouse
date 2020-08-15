extends RigidBody2D

func _input(event):
	if event.is_action_pressed("launch"):
		var mouse_vec = get_local_mouse_position().rotated(rotation)
		apply_central_impulse(mouse_vec)
