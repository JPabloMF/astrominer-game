extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 250
var motion = Vector2()
export (String,"right","left","up","down") var initialDirection
const DIRECTIONS = {"RIGHT": "right", "LEFT": "left", "UP": "up", "DOWN": "down"}
var flyDistance = 100
var gems_ammount = 0
var has_shield = true
var _timer = null

onready var energy_bar = $EnergyBar
onready var player_energy = $Energy

onready var gem_indicator_label = $GemsIndicator/Label

func get_timer():
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1.5)
	_timer.set_one_shot(false) # Make sure it loops
	
func start_timer():
	_timer.start()
	
func stop_timer():
	_timer.stop()

func _ready():
	player_energy.connect("changed",energy_bar,"set_value")
	player_energy.connect("max_changed",energy_bar,"set_max")
	player_energy.initialize()
	get_timer()
	
func get_which_wall_collided():
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.normal.x > 0:
			return "left"
		elif collision.normal.x < 0:
			return "right"
	return "none"
	
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
			player_energy.current = flyDistance
	else:
		if flyDistance < 100:
			if is_on_floor():
				flyDistance += 1
			else:
				flyDistance += 0.5
			player_energy.current = flyDistance
	
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
	handle_horizontal_movement()
	handle_vertical_movement()
	
	motion = move_and_slide(motion,Vector2.UP)

func handle_gem_picked():
	gems_ammount += 1
	gem_indicator_label.text = "0{gems_ammount} / 04".format({"gems_ammount": str(gems_ammount)})

func handle_take_damage():
	if not has_shield:
		get_tree().reload_current_scene()

func handle_shield_take_damage():
	remove_child($Shield)
	start_timer()

func _on_Timer_timeout():
	has_shield = false

func _on_Player_area_entered(area):
	var area_name = area.get_name()
	match area_name:
		"Gem":
			handle_gem_picked()
		"Trap":
			handle_take_damage()

func _on_Shield_area_entered(area):
	var area_name = area.get_name()
	match area_name:
		"Trap":
			handle_shield_take_damage()
