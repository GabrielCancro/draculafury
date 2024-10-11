extends Node

var probability_base = 15
var probability = probability_base

var ITEMS_DATA = {
	"crucifix": {"ico":0},
	"garlic": {"ico":1},
	#"stake": {"ico":2},
	#"potion": {"ico":3},
	"ron": {"ico":4},
	"dice": {"ico":5},
}
var ITEMS_INFLOOR = []
var ITEMS_PLAYER = []
signal end_item_action()

func get_item_data(code):
	var _data = ITEMS_DATA[code].duplicate()
	_data["code"]=code
	return _data

func throw_item(code, xpos=null):
	var it = preload("res://nodes/ItemNode.tscn").instance()
	var data = get_item_data(code)
	it.set_data(data)
	it.rect_position = Vector2(1000,600)
	if xpos: it.rect_position.x = xpos
	ITEMS_INFLOOR.append(it)
	get_node("/root/Game/ItemContainer").add_child(it)

func throw_random_item(xpos=null):
	randomize()
	var rnd_index = randi()%ITEMS_DATA.keys().size()
	throw_item( ITEMS_DATA.keys()[rnd_index], xpos )

func take_item(item_node):
	if item_node.is_infloor:
		item_node.is_infloor = false
		ITEMS_INFLOOR.erase(item_node)
		ITEMS_PLAYER.append(item_node)
		reorder_items()

func throw_with_probability(xpos=null):
	randomize()
	if randi()%100<probability:
		probability = probability_base
		throw_random_item(xpos)
	else:
		probability *= 2

func reorder_items():
	var i = 0
	for it in ITEMS_PLAYER:
		if !it.is_infloor:
			it.move_to_pos(Vector2(30,130+80*(ITEMS_PLAYER.size()-i)))
			i+=1

func use_item(item_node):
	$Button.disabled = true
	Effector.disappear(self)
	yield(get_tree().create_timer(.5),"timeout")
	queue_free()
	reorder_items()

func run_item_action(code):
	yield(get_tree().create_timer(.2),"timeout")
	#if !PLAYER: PLAYER = get_node("/root/Game/Player")
	if has_method("_condition_"+code) && !call("_condition_"+code):
		Effector.show_float_text("NO EFFECT!")
		yield(get_tree().create_timer(.5),"timeout")
		emit_signal("end_item_action",false)
	else:
		#PLAYER.set_anim(code)
		if has_method("_condition_"+code):
			call("_run_"+code)
			yield(self,"end_item_action")
		else:
			emit_signal("end_item_action",false)

func _condition_garlic(): return PlayerManager.PLAYER_STATS.hp<PlayerManager.PLAYER_STATS.hpm
func _run_garlic():
	PlayerManager.heal(2)
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("end_item_action",true)
	
func _condition_crucifix(): return EnemyManager.have_close_enemy(999)
func _run_crucifix():
	for en in EnemyManager.ENEMIES_ACTIVES:
		en.enemy_damage(1)
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("end_item_action",true)

func _condition_dice(): return true
func _run_dice():
	var new_dice = get_node("/root/Game/CLUI/DiceSet").add_extra_dice()
	if new_dice: new_dice.roll()
	emit_signal("end_item_action",true)

func _condition_ron(): return true
func _run_ron():
	var army = get_node("/root/Game/CLUI/Belt").current_slot.army
	get_node("/root/Game/CLUI/PlayerActionList").add_army(army)
	emit_signal("end_item_action",true)
