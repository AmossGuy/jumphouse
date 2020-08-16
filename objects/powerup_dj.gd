extends Area2D

func _on_powerup_dj_body_entered(body):
	if body.is_class("ball"):
		body.has_double_jump = true
		$shatter_sound.play()
		
		visible = false
		monitoring = false
		monitorable = false

func _on_shatter_sound_finished():
	queue_free()
