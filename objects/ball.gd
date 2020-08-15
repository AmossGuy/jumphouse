extends RigidBody2D

var on_floor = false

func update_arrows(count: int, dir: float):
	var arrows := [$arrow1, $arrow2, $arrow3]

func _input(event):
	if event.is_action_pressed("launch") and on_floor:
		var mouse_vec = get_local_mouse_position().rotated(rotation)
		apply_central_impulse(mouse_vec.normalized() * 100)

func _integrate_forces(s):
	on_floor = false
	for x in range(s.get_contact_count()):
		var ci = s.get_contact_local_normal(x)
		if ci.dot(Vector2(0, -1)) > 0.6:
			on_floor = true
