extends Node

var ENEMIES_ACTIVES = []
var max_x_pos = 5
var end_x_pos = 500
var ENEMIES = {
	"vampire":{"hp":5,"mov":1,"dam":2, "ran":1,"fly":false,"ability":"extra_mov"},
	"bat":{"hp":3,"mov":2,"dam":1, "ran":1,"fly":true}
}

func _ready(): initialize_data()

func initialize_data():
	ENEMIES_ACTIVES = []

func get_enemy_data(code):
	var data = ENEMIES[code].duplicate()
	if !"ret" in data: data["ret"] = ENEMIES.keys().find(code)
	data.name = code
	return data

func add_enemy(code):
	var data = get_enemy_data(code)
	var _ypos = 0
	if data.fly: _ypos = 1
	var _xpos = get_rnd_free_xpos(_ypos)
	if _xpos!=-1:
		var node = preload("res://nodes/Enemy.tscn").instance()
		node.set_data(data,_xpos)
		get_node("/root/Game/Enemies").add_child(node)
		ENEMIES_ACTIVES.append(node)
		return node
	else:
		return null

func get_rnd_free_xpos(_ypos=0):
	randomize()
	var arr = [1,2,3,4,5,6,7,8,9,10]
	arr.shuffle()
	for _xpos in arr:
		if _xpos>=max_x_pos: continue
		if get_enemy_in_pos(_xpos,_ypos): continue
		else: return _xpos
	return -1

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

func get_first_enemy(ran=max_x_pos+1,forced_y=-1):
	re_ordered_enemies_array()
	for en in ENEMIES_ACTIVES:
		if en.enemy_data.tile_pos_x < ran: 
			if forced_y == -1 || en.enemy_data.tile_pos_y == forced_y: 
				return en
	return null

func get_enemy_in_same_column(enemy):
	if !enemy: return null
	return get_enemy_in_pos(enemy.enemy_data.tile_pos_x, abs(enemy.enemy_data.tile_pos_y-1))

func get_next_in_same_row(enemy):
	if !enemy: return null
	return get_enemy_in_pos(enemy.enemy_data.tile_pos_x+1, enemy.enemy_data.tile_pos_y)

func sort_custom(a,b):
	return ( a.z_index > b.z_index )

func get_frame(enemy):
	return ENEMIES.keys().find(enemy)

func move_to_first_free_space(en,ran=1):
	if !is_instance_valid(en): return
	var candidate = en.enemy_data.tile_pos_x
	for _x in range(en.enemy_data.tile_pos_x,EnemyManager.max_x_pos+1):
		if !get_enemy_in_pos(_x,en.enemy_data.tile_pos_y):
			candidate = _x
			if _x >= en.enemy_data.tile_pos_x+ran: break
	en.set_tile_pos(candidate)

func have_close_enemy(ran=max_x_pos+1,forced_y=-1):
	re_ordered_enemies_array()
	for en in ENEMIES_ACTIVES:
		if en.enemy_data.tile_pos_x < ran: 
			if forced_y == -1 || en.enemy_data.tile_pos_y == forced_y:
				return true
	return false

func force_move_enemy():
	for en in re_ordered_enemies_array():
		en.move()
