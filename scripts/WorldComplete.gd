extends AnimatedSprite

export(String,FILE,"*.tscn") var next_world

var gems_ammount = 0

func _on_WorldComplete_area_entered(area):
	print(gems_ammount)
	if area.get_name() == "Player" and gems_ammount == 4:
		play("open")
		$Timer.start()

func _on_Timer_timeout():
	get_tree().change_scene(next_world)

func _on_get_gem(type):
	match type:
		"blue":
			$blueDiamond.show()
			gems_ammount = gems_ammount + 1
		"green":
			$greenDiamond.show()
			gems_ammount = gems_ammount + 1
		"pink":
			$pinkDiamond.show()
			gems_ammount = gems_ammount + 1
		"yellow":
			$yellowDiamond.show()
			gems_ammount = gems_ammount + 1
