extends Control

var pause_visible = false

func _ready():
	pass # Replace with function body.

func pause():
	get_tree().paused = true
	pause_visible = true
	
func unpause():
	get_tree().paused = false
	pause_visible = false

func handle_pause():
	if Input.is_action_just_pressed("ui_cancel"):
		if pause_visible:
			hide()
			unpause()
		else:
			show()
			pause()

func _physics_process(delta):
	handle_pause()

func _on_Restart_button_down():
	unpause()
	get_tree().reload_current_scene()

func _on_Exit_button_down():
	get_tree().quit()

func _on_Resume_button_down():
	hide()
	unpause()
