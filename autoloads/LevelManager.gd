extends Node

var current_level = 1

func _ready():
	pass # Replace with function body.

func goto_level(_lv):
	current_level = _lv
	print("CURRENT LEVEL IS ",current_level)
	get_tree().change_scene("res://scenes/Game.tscn")
