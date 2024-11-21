extends Node

var current_level = 1

var ALL_WAVES = {
	"lv_1":[
		["1*vampire",null,"1*vampire",null,"1*vampire"],
		["2*vampire",null,null,"2*bat"],
		["1*bat",null,"1*bat","1*vampire",null,"2*bat"],
	],
	"lv_2":[
		["1*bat","1*gargoyle","1*vampire",null,"1*vampire"],
		["2*vampire",null,"1*gargoyle","2*bat"],
		["3*bat",null,null,"1*vampire",null,"2*bat"],
		["1*bat",null,"1*gargoyle",null,"1*gargoyle",null,"2*bat"],
	],
	"lv_3":[
		["1*vampire",null,"2*wolf","1*bat","1*vampire"],
		["1*vampire","1*wolf",null,"2*wolf",null,null,"2*bat"],
		["1*vampire",null,"2*wolf","1*bat","1*vampire"],
		["1*vampire","1*wolf",null,"2*wolf",null,null,"2*bat"],
		["3*wolf",null,null,"2*wolf",null,null,null,"3*wolf"],
	],
}

func _ready():
	pass # Replace with function body.

func get_level_waves():
	var waves = ALL_WAVES["lv_"+str(current_level)].duplicate()
	print("WAVES ",current_level)
	print(waves)
	return waves

func set_map_spaces():
	if current_level == 1: EnemyManager.max_x_pos = 5
	elif current_level == 2: EnemyManager.max_x_pos = 6
	elif current_level == 3: EnemyManager.max_x_pos = 7
