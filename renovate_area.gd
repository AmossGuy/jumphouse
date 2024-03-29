extends Area2D

export(NodePath) var removed
export(NodePath) var added

func _ready():
	get_node(added).position = Vector2(INF, INF)

func _on_renovate_area_body_entered(body):
	if body.is_class("ball"):
		get_node(removed).queue_free()
		get_node(added).position = Vector2(0, 0)
		self.queue_free()
