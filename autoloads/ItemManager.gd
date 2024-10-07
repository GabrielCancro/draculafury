extends Node

var ITEMS_DATA = {}
var ITEMS_INFLOOR = []
var ITEMS_PLAYER = []

func throw_random_item():
	var it = preload("res://nodes/ItemNode.tscn").instance()
	randomize()
	it.set_data( {"code":"cruz","ico":randi()%4} )
	it.rect_position = Vector2(1000,580)
	ITEMS_INFLOOR.append(it)
	get_node("/root/Game/ItemContainer").add_child(it)

func take_item(item_node):
	if item_node.is_infloor:
		item_node.is_infloor = false
		ITEMS_INFLOOR.erase(item_node)
		ITEMS_PLAYER.append(item_node)
		reorder_items()

func reorder_items():
	var i = 0
	for it in ITEMS_PLAYER:
		if !it.is_infloor:
			it.move_to_pos(Vector2(30,130+80*(ITEMS_PLAYER.size()-i)))
			i+=1
