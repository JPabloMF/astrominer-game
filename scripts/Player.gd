extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 350
const MAX_SPEED_AIR = 250
var motion = Vector2()

var flyDistance = 100
var gems_ammount = 0
var has_shield = true
var _timer = null
var player_is_in_trap = false

onready var energy_bar = $CanvasLayer/EnergyBar
onready var player_energy = $CanvasLayer/Energy
#onready var gem_indicator_label = $CanvasLayer/GemsIndicator/Label

export(String,FILE,"*.tscn") var mini_map

func load_minimap():
	var scene = load(mini_map)
	var instacedScene = scene.instance()
	$CanvasLayer/ViewportContainer/Viewport.add_child(instacedScene)

func _ready():
	player_energy.connect("changed",energy_bar,"set_value")
	player_energy.connect("max_changed",energy_bar,"set_max")
	player_energy.initialize()
	load_minimap()

#func set_energybar_color(ammount):
#	match ammount:
#		90:
#			$CanvasLayer/EnergyBar.
#		85:
#			$CanvasLayer/GemsIndicator/greenDiamond.show()
#		80:
#			$CanvasLayer/GemsIndicator/pinkDiamond.show()
#		75:
#			$CanvasLayer/GemsIndicator/yellowDiamond.show()

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
		if not is_on_floor():
			motion.x = max(motion.x - ACCELERATION, -MAX_SPEED_AIR)
		else:
			motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
	elif Input.is_action_pressed("ui_right"):
		if not is_on_floor():
			motion.x = min(motion.x + ACCELERATION, MAX_SPEED_AIR)
		else:
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
	handle_take_damage()
	
	motion = move_and_slide(motion,Vector2.UP)

func handle_gem_picked(type):
	match type:
		"blue":
			$CanvasLayer/GemsIndicator/blueDiamond.show()
		"green":
			$CanvasLayer/GemsIndicator/greenDiamond.show()
		"pink":
			$CanvasLayer/GemsIndicator/pinkDiamond.show()
		"yellow":
			$CanvasLayer/GemsIndicator/yellowDiamond.show()

func handle_take_damage():
	if not has_shield and $StayTrapTimer.is_stopped():
		$StayTrapTimer.start()

func handle_shield_take_damage():
	remove_child($Shield)
	has_shield = false

func _on_Player_area_entered(area):
	var area_name = area.get_name()
	match area_name:
		"Trap":
			player_is_in_trap = true

func _on_Player_area_exited(area):
	var area_name = area.get_name()
	match area_name:
		"Trap":
			player_is_in_trap = false

func _on_Shield_area_entered(area):
	var area_name = area.get_name()
	match area_name:
		"Trap":
			handle_shield_take_damage()

func _on_StayTrapTimer_timeout():
	if player_is_in_trap:
		get_tree().reload_current_scene()

func _on_get_gem(type):
	handle_gem_picked(type)
