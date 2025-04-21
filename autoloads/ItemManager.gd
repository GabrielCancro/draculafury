extends Node

var probability_base = 15
var probability = probability_base
var items_usage_enabled = false

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


func initialize_data():
	ITEMS_INFLOOR = []
	ITEMS_PLAYER = []

func get_item_data(code):
	var _data = ITEMS_DATA[code].duplicate()
	_data["code"]=code
	return _data

func throw_item(code, xpos=null):
	var it = load("res://nodes/ItemNode.tscn").instance()
	var data = get_item_data(code)
	it.set_data(data)
	it.rect_position = Vector2(1000,700)
	if xpos: it.rect_position.x = xpos
	ITEMS_INFLOOR.append(it)
	get_node("/root/Game/CLUI/ItemContainer").add_child(it)

func throw_random_item(xpos=null):
	randomize()
	var rnd_index = randi()%ITEMS_DATA.keys().size()
	throw_item( ITEMS_DATA.keys()[rnd_index], xpos )

func take_item(item_node):
	if ITEMS_PLAYER.size()>=3:
		Effector.show_float_text("have_many_items")
		return
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
	var dist = 80 #* SizerManager.current_scale
	for it in ITEMS_PLAYER:
		if !is_instance_valid(it): continue
		it.rect_scale = Vector2(1,1)
		if !it.is_infloor:
			it.move_to_pos(Vector2(80+dist*(i+1),45+dist*1.5))
			#it.rect_scale *= SizerManager.current_scale
			i+=1
	enable_items_usage(items_usage_enabled)

func run_item_action(code):
	yield(get_tree().create_timer(.2),"timeout")
	#if !PLAYER: PLAYER = get_node("/root/Game/Player")
	if has_method("_condition_"+code) && !call("_condition_"+code):
		Effector.show_float_text("ui_no_effect")
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
	if new_dice: 
		new_dice.roll()
		yield(new_dice,"end_roll")
		if new_dice.value == 6: 
			Effector.scale_boom(new_dice)
			yield(get_tree().create_timer(.3),"timeout")
			_run_dice()
		emit_signal("end_item_action",true)
	else:
		emit_signal("end_item_action",false)

func _condition_ron(): return true
func _run_ron():
	var belt = get_node("/root/Game/CLUI/Belt")
	var player_action_list = get_node("/root/Game/CLUI/PlayerActionList")
	belt.current_slot.set_lighted(true)
	yield(get_tree().create_timer(.5),"timeout")
	if belt.current_slot.reduce_amount():
		player_action_list.add_army(belt.current_slot.army)
	belt.clear_selected_slot()
	yield(get_tree().create_timer(.2),"timeout")
	emit_signal("end_item_action",true)

func enable_items_usage(val):
	items_usage_enabled = val
	for it in ITEMS_PLAYER:
		if !it.is_infloor:
			if val: it.modulate = Color(1,1,1,1)
			else: it.modulate = Color(.4,.4,.4,1)

func clear_floor_items():
	for it in ITEMS_INFLOOR: Effector.disappear(it)
	yield(get_tree().create_timer(.7),"timeout")
	for it in ITEMS_INFLOOR:
		ITEMS_INFLOOR.erase(it)
		it.queue_free()
