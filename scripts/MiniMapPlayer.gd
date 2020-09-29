extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 250
var motion = Vector2()
var flyDistance = 100

func _ready():
	pass # Replace with function body.

func handle_apply_gravity():
	motion.y += 25
	
func handle_vertical_movement():
	if Input.is_action_pressed("ui_up"):
		if is_on_floor():
			motion.y = -600
	if Input.is_action_pressed("ui_fly"):
		if flyDistance >= 0:
			flyDistance -= 1
			motion.y = -300
	else:
		if flyDistance < 100:
			if is_on_floor():
				flyDistance += 1
			else:
				flyDistance += 0.5
	
func handle_horizontal_movement():
	if Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
	elif Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
	else:
		if not is_on_floor():
			motion.x = lerp(motion.x, 0, 0.2)
		else:
			motion.x = lerp(motion.x, 0, 1)

func _physics_process(delta):
	handle_apply_gravity()
	handle_vertical_movement()
	handle_horizontal_movement()

	motion = move_and_slide(motion,Vector2.UP)
