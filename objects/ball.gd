extends KinematicBody2D

class_name ball
func get_class():
	return "ball"
func is_class(name: String):
   return .is_class(name) or (get_class() == name)

const GRAVITY := 98
const FRICTION := 170
const ARROW_OFFSET := 16
const LAUNCH_FORCE := 100
const FLOOR_SLIDE_RANGE := 45

var velocity := Vector2.ZERO
var special_launch = false

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
	if event.is_action_pressed("launch"):
		var launch_vec := get_launch_vec()
		if launch_vec != Vector2.INF:
			special_launch = false
			velocity = launch_vec

func launch_charged() -> bool:
	return is_on_floor() or special_launch

func test_launch(v: Vector2) -> Vector2:
	var launch_vec := v
	var test_vec := launch_vec.normalized() * 8
	var collision := move_and_collide(test_vec, true, true, true)
	
	if collision != null \
		and launch_vec.angle() >= deg2rad(0) \
		and launch_vec.angle() <= deg2rad(FLOOR_SLIDE_RANGE):
			launch_vec = Vector2.RIGHT * launch_vec.length()
			test_vec = launch_vec.normalized() * 8
			collision = move_and_collide(test_vec, true, true, true)
	
	if collision != null \
		and launch_vec.angle() >= deg2rad(FLOOR_SLIDE_RANGE + 90) \
		and launch_vec.angle() <= deg2rad(180):
			launch_vec = Vector2.LEFT * launch_vec.length()
			test_vec = launch_vec.normalized() * 8
			collision = move_and_collide(test_vec, true, true, true)
	
	return launch_vec if collision == null and launch_charged() else Vector2.INF

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
			+ Vector2.RIGHT.rotated(angle) \
			.normalized() * ARROW_OFFSET * (i+1)
