extends Node2D

export (String,FILE,"*.png") var diamond_sprite
export (String,"blue","green","pink","yellow") var diamond_color = "blue"

func load_diamond_animation():
	var sprite
	match diamond_color:
		"blue":
			sprite = load("res://animations/diamond/DiamondBlue.tres")
		"green":
			sprite = load("res://animations/diamond/DiamondGreen.tres")
		"pink":
			sprite = load("res://animations/diamond/DiamondPink.tres")
		"yellow":
			sprite = load("res://animations/diamond/DiamondYellow.tres")
	$Diamond.set_sprite_frames(sprite)

func _ready():
	load_diamond_animation()

func _on_Coin_area_entered(area):
	if "Player" in area.get_name():
		remove_child($Diamond)
		$collisionTimer.start()

func _on_collisionTimer_timeout():
	remove_child($Gem)
