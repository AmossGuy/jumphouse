extends Area2D

export(NodePath) var hidden

func _on_win_area_body_entered(body):
	if body.is_class("ball"):
		get_node(hidden).visible = true
		body.queue_free()
		$win_sound.play()
