extends Area2D

func _on_powerup_dj_body_entered(body):
	if body.is_class("ball"):
		body.has_double_jump = true
		body.double_jump_charged = true
		$shatter_sound.play()
		
		visible = false
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)

func _on_shatter_sound_finished():
	queue_free()
