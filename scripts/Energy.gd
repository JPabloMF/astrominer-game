extends Node

signal max_changed(new_max)
signal changed(new_ammount)
signal depleted

export(int) var max_ammount = 100 setget set_max
onready var current = max_ammount	setget set_current

func _ready():
	initialize()

func set_max(new_max):
	max_ammount = new_max
	max_ammount = max(1, new_max) # always above 1
	emit_signal("max_changed",max_ammount)
	
func set_current(new_value):
	current = new_value
	current = clamp(current, 0 , max_ammount) # current never will be lower than 0 and max than max_amount
	emit_signal("changed",current)
	
	if current == 0:
		emit_signal("depleted")

func initialize():
	emit_signal("max_changed", max_ammount)
	emit_signal("changed", current)
