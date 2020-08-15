extends RigidBody2D

class_name ball
func get_class():
	return "ball"
func is_class(name: String):
   return .is_class(name) or (get_class() == name)

var on_floor := false
var special_launch := false

func update_arrows(count: int, dir: float):
	var arrows := [$arrow1, $arrow2, $arrow3]

func _input(event):
	if event.is_action_pressed("launch") and (on_floor or special_launch):
		special_launch = false
		var mouse_vec = get_local_mouse_position().rotated(rotation)
		linear_velocity = linear_velocity \
			.rotated(-mouse_vec.angle())
		linear_velocity.y = 0
		linear_velocity = linear_velocity \
			.rotated(mouse_vec.angle())
		apply_central_impulse(mouse_vec.normalized() * 100)

func _integrate_forces(s):
	on_floor = false
	for x in range(s.get_contact_count()):
		var ci = s.get_contact_local_normal(x)
		if ci.dot(Vector2(0, -1)) > 0.6:
			on_floor = true
