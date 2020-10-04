extends Control

func _on_Start_button_down():
	get_tree().change_scene("res://scenes/worlds/dirt/World1/World1.tscn")


func _on_Quit_button_down():
	get_tree().quit()
