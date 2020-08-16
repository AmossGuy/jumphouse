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
const WALL_SLIDE_ANGLE := 20
const WALL_SLIDE_RANGE := 70

var velocity := Vector2.ZERO
var special_launch = false
var has_double_jump = false
var double_jump_charged = false

func _physics_process(delta: float):
	velocity += Vector2.DOWN * GRAVITY * delta
	if is_on_floor():
		if has_double_jump:
			double_jump_charged = true
		if velocity.x > 0:
			velocity.x -= FRICTION * delta
			velocity.x = max(velocity.x, 0)
		elif velocity.x < 0:
			velocity.x += FRICTION * delta
			velocity.x = min(velocity.x, 0)
	var slid_velocity = move_and_slide(velocity, Vector2.UP)
	if not (is_on_wall() and velocity.y < 0):
		velocity = slid_velocity
	
	var launch_vec := get_launch_vec()
	var arrow_count = int(launch_vec != Vector2.INF)
	if arrow_count != 0:
		arrow_count += int(
			double_jump_charged and (is_on_floor() or special_launch)
		)
	update_arrows(arrow_count, launch_vec.angle())

func _input(event):
	if event.is_action_pressed("launch"):
		var launch_vec := get_launch_vec()
		if launch_vec != Vector2.INF:
			if not (is_on_floor() or special_launch):
				double_jump_charged = false
			special_launch = false
			velocity = launch_vec

func launch_charged() -> bool:
	return is_on_floor() or special_launch or double_jump_charged

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
	
	if collision != null \
		and launch_vec.angle() >= deg2rad(-90) \
		and launch_vec.angle() <= deg2rad(-90 + WALL_SLIDE_RANGE):
			launch_vec = Vector2.UP.rotated(deg2rad(WALL_SLIDE_ANGLE)) \
				* launch_vec.length()
			test_vec = Vector2.UP * 8
			collision = move_and_collide(test_vec, true, true, true)
	
	if collision != null \
		and launch_vec.angle() >= deg2rad(-90 - WALL_SLIDE_RANGE) \
		and launch_vec.angle() <= deg2rad(-90):
			launch_vec = Vector2.UP.rotated(deg2rad(-WALL_SLIDE_ANGLE)) \
				* launch_vec.length()
			test_vec = Vector2.UP * 8
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
