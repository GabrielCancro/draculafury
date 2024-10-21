extends Node

var current_level = 1

var ALL_WAVES = {
	"lv_1":[
		["1*vampire",null,"1*vampire",null,"1*vampire"],
		["2*vampire",null,null,"2*bat"],
		["1*bat",null,"1*bat","1*vampire",null,"2*bat"],
	],
}

func _ready():
	pass # Replace with function body.

func goto_level(_lv):
	current_level = _lv
	print("CURRENT LEVEL IS ",current_level)
	get_tree().change_scene("res://scenes/Game.tscn")

func get_level_waves():
	var waves = ALL_WAVES["lv_"+str(current_level)].duplicate()
	print("WAVES ",current_level)
	print(waves)
	return waves
