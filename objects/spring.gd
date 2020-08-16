extends Area2D

export var STRENGTH := 100

func _on_spring_body_entered(body):
	if body.is_class("ball"):
		body.velocity = Vector2.RIGHT.rotated(rotation - deg2rad(90)) * STRENGTH
		body.special_launch = true
		if body.has_double_jump:
			body.double_jump_charged = true
		
		$AnimatedSprite.stop()
		$AnimatedSprite.play("spring")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "spring":
		$AnimatedSprite.play("default")
