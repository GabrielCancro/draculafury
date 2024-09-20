extends Node

var ENEMIES_ACTIVES = []
var max_x_pos = 8
var ENEMIES = {
	"vampire":{"hp":20,"mov":2,"dam":1, "ran":1,"fly":false},
	"bat":{"hp":10,"mov":2,"dam":1, "ran":1,"fly":true},
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

func re_ordered_enemies_array():
	ENEMIES_ACTIVES.sort_custom(self, "sort_custom")
	for i in range(ENEMIES_ACTIVES.size()):
		move_child( ENEMIES_ACTIVES[i], i )
	return ENEMIES_ACTIVES

func get_first_enemy(ran=8):
	re_ordered_enemies_array()
	if ENEMIES_ACTIVES.size()<=0: return null
	else: 
		if ENEMIES_ACTIVES[0].enemy_data.tile_pos_x<ran: return ENEMIES_ACTIVES[0]
		else: return null

func sort_custom(a,b):
	return ( a.z_index > b.z_index )

func get_frame(enemy):
	return ENEMIES.keys().find(enemy)

func move_to_first_free_space(en):
	for _x in range(en.enemy_data.tile_pos_x,8):
		if !get_enemy_in_pos(_x,0):
			en.set_tile_pos(_x)
			break
	return false
