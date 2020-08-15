extends KinematicBody2D

const GRAVITY := 98
const FRICTION := 170
const ARROW_OFFSET := 16
const LAUNCH_FORCE := 100

var velocity := Vector2.ZERO

func _process(delta: float):
	velocity += Vector2.DOWN * GRAVITY * delta
	if is_on_floor():
		if velocity.x > 0:
			velocity.x -= FRICTION * delta
			velocity.x = max(velocity.x, 0)
		elif velocity.x < 0:
			velocity.x += FRICTION * delta
			velocity.x = min(velocity.x, 0)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var launch_vec := get_launch_vec()
	update_arrows(1 if launch_vec != Vector2.INF else 0, launch_vec.angle())

func _input(event):
	if event.is_action_pressed("launch") and is_on_floor():
		var launch_vec := get_launch_vec()
		if launch_vec != Vector2.INF:
			velocity = launch_vec

func test_launch(launch_vec: Vector2) -> Vector2:
	var collision := move_and_collide(launch_vec, true, true, true)
	return launch_vec if collision == null else Vector2.INF

func get_launch_vec() -> Vector2:
	var launch_vec := get_local_mouse_position().rotated(rotation) \
		.normalized() * LAUNCH_FORCE
	launch_vec = test_launch(launch_vec)
	return launch_vec

func update_arrows(count: int, angle: float):
	var arrows := [$arrow1, $arrow2, $arrow3]
	
	for i in range(arrows.size()):
		arrows[i].visible = i < count
		arrows[i].global_rotation = angle
		arrows[i].global_position = global_position \
			+ get_local_mouse_position().rotated(rotation) \
			.normalized() * ARROW_OFFSET * (i+1)
