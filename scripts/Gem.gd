extends Node2D

export (String,FILE,"*.png") var diamond_sprite
export (String,"blue","green","pink","yellow") var diamond_color = "blue"

signal get_gem

func load_diamond_animation():
	var sprite
	match diamond_color:
		"blue":
			sprite = load("res://animations/diamond/DiamondBlue.tres")
			$Light.set_color(Color(63,63,191,0.01))
		"green":
			sprite = load("res://animations/diamond/DiamondGreen.tres")
			$Light.set_color(Color(63,191,63,0.005))
		"pink":
			sprite = load("res://animations/diamond/DiamondPink.tres")
			$Light.set_color(Color(191,63,127,0.005))
		"yellow":
			sprite = load("res://animations/diamond/DiamondYellow.tres")
			$Light.set_color(Color(191,127,63,0.005))
	$Diamond.set_sprite_frames(sprite)

func _ready():
	load_diamond_animation()

func _on_Coin_area_entered(area):
	if "Player" in area.get_name():
		emit_signal("get_gem",diamond_color)
		remove_child($Diamond)
		$collisionTimer.start()

func _on_collisionTimer_timeout():
	remove_child($Gem)
	remove_child($Light)
