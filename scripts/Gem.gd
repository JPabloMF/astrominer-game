extends Sprite

func _ready():
	pass # Replace with function body.

func _on_Coin_area_entered(area):
	if "Player" in area.get_name():
		queue_free()

