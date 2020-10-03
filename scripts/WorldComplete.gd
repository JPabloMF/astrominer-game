extends AnimatedSprite

export(String,FILE,"*.tscn") var next_world

var gems_ammount = 0

func _on_WorldComplete_area_entered(area):
	print(gems_ammount)
	if area.get_name() == "Player" and gems_ammount == 4:
		play("open")
		$Timer.start()

func _on_Player_gems_ammount_changed(ammount):
	gems_ammount = ammount
	match ammount:
		0:
			play("default")
		1:
			play("1diamond")
		2:
			play("2diamond")
		3:
			play("3diamond")
		4:
			play("4diamond")

func _on_Timer_timeout():
	get_tree().change_scene(next_world)
