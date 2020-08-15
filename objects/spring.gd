extends Area2D

func _on_spring_body_entered(body):
	if body.is_class("RigidBody2D"):
		body.linear_velocity = body.linear_velocity \
			.rotated(-global_rotation)
		body.linear_velocity.y = 0
		body.linear_velocity = body.linear_velocity \
			.rotated(global_rotation)
		body.apply_impulse(
			position - body.position,
			Vector2(0, -150).rotated(rotation)
		)
		$AnimatedSprite.stop()
		$AnimatedSprite.play("spring")
		
		if body.is_class("ball"):
			body.special_launch = true

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "spring":
		$AnimatedSprite.play("default")
