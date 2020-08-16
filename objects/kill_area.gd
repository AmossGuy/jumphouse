extends Area2D

export(NodePath) var destination

func _on_kill_area_body_entered(body):
	if body.is_class("ball"):
		$splash_sound.global_position = body.global_position
		$splash_sound.play()
		
		body.velocity = Vector2.ZERO
		body.global_position = get_node(destination).global_position
