extends Area2D

export var respawns := true

var timer := 0.0
var timer_active := false

func _process(delta):
	if timer_active:
		timer += delta
		if timer >= 3:
			$respawn_sound.play()
			
			visible = true
			set_deferred("monitoring", true)
			set_deferred("monitorable", true)
			
			timer_active = false

func _on_powerup_dj_body_entered(body):
	if body.is_class("ball"):
		body.has_double_jump = true
		body.double_jump_charged = true
		$shatter_sound.play()
		
		visible = false
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)
		
		timer_active = true
		timer = 0.0

func _on_shatter_sound_finished():
	if not respawns:
		queue_free()
