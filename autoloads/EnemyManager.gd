extends Node

var ENEMIES_ARRAY = []

var ENEMIES = {
	"goblin":{"img":"enemy01","mov":2,"dam":1,"fly":false}
}

func get_enemy_data(code):
	var data = ENEMIES[code].duplicate()
	data.name = code
	return data

func add_enemy(code):
	var node = preload("res://nodes/Enemy.tscn").instance()
	var data = get_enemy_data(code)
	node.set_data(data)
	get_node("/root/Game/Enemies").add_child(node)
	return node

