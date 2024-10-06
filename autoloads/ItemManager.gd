extends Node

var ITEMS_DATA = {}
var ITEMS_INGAME = []

func throw_random_item():
	var it = preload("res://nodes/ItemNode.tscn").instance()
	it.set_data( {"code":"cruz","ico":1} )
	it.rect_position = Vector2(1000,580)
	ITEMS_INGAME.append(it)
	get_node("/root/Game/ItemContainer").add_child(it)

func reorder_items():
	var i = 0
	for it in ITEMS_INGAME:
		if !it.is_infloor:
			it.move_to_pos(Vector2(50,230+50*i))
			i+=1
