extends Node

signal end_army_action()

var ARMIES = ["kick","rapier","gun","shotgun","crossbow","stake","dynamite","dynamite","dynamite","dynamite"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func run_army_action(code):
	Effector.show_float_text("army_"+code)
	yield(get_tree().create_timer(2.5),"timeout")
	emit_signal("end_army_action")
