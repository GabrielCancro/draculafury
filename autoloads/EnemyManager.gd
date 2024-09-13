extends Node

var ENEMIES_ACTIVES = []

var ENEMIES = {
	"vampire":{"mov":2,"dam":1, "ran":1,"fly":false},
	"bat":{"mov":2,"dam":1, "ran":1,"fly":true},
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
	ENEMIES_ACTIVES.append(node)
	return node

func add_rnd_enemy():
	randomize()
	var code = ENEMIES.keys()[ randi()%ENEMIES.keys().size() ]
	add_enemy(code)

func get_enemy_in_pos(_x,_y):
	for en in ENEMIES_ACTIVES: 
		if (en.enemy_data["tile_pos_y"] == _y 
		and en.enemy_data["tile_pos_x"] == _x): 
			return en
	return null

func swap_enemies(en1,en2):
	#print("SWAP ENEMIES ",en1.name," <-> ",en2.name)
	var pos1 = en1.enemy_data.tile_pos_x
	var pos2 = en2.enemy_data.tile_pos_x
	en1.set_tile_pos(pos2)
	en2.set_tile_pos(pos1)
