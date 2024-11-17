extends Control

var WaveSlot = preload("res://nodes/WaveSlot.tscn")
var space_slot = 105
var max_slots = 3
var wave_index = 0

var first_tuto_enemy 

signal end_wave_anim()

var WAVE = []
var ALL_WAVES = [
	["1*vampire",null,"1*vampire",null,"1*vampire"],
	["2*vampire",null,null,"2*bat"],
	["1*bat",null,"1*bat","1*vampire",null,"2*bat"],
	["1*bat","1*gargoyle","1*vampire",null,"1*vampire"],
	["2*vampire",null,"1*gargoyle","2*bat"],
	["3*bat",null,null,"1*vampire",null,"2*bat"],
	["1*bat",null,"1*gargoyle",null,"1*gargoyle",null,"2*bat"],
	["1*vampire",null,"2*wolf","1*bat","1*vampire"],
	["1*vampire","1*wolf",null,"2*wolf",null,null,"2*bat"],
	["1*vampire",null,"2*wolf","1*bat","1*vampire"],
	["1*vampire","1*wolf",null,"2*wolf",null,null,"2*bat"],
	["3*wolf",null,null,"2*wolf",null,null,null,"3*wolf"],
]

func _ready():
	$lb_wave.text = ""
	Effector.remove_all_children($Grid)
	#ALL_WAVES = LevelManager.get_level_waves()

func next_wave():
	wave_index += 1
	WAVE = ALL_WAVES[wave_index-1].duplicate()
	$lb_wave.text = "WAVE\n"+str(wave_index)+"/"+str(ALL_WAVES.size()+wave_index)
	Effector.remove_all_children($Grid)
	yield(get_tree().create_timer(.5),"timeout")
	for i in range(max_slots): add_slot(WAVE[i])

func advance_wave():
	if WAVE.size()<=0: return false
	var slot_info = get_slot_info( WAVE[0] )
	var sl = $Grid.get_child(0)
	var skip_slot = false 
	
	$Tween.interpolate_property(sl,"rect_position",null,sl.rect_position+Vector2(10,55),.3,Tween.TRANS_QUAD,Tween.EASE_IN)
	$Tween.start()
	yield(get_tree().create_timer(.3),"timeout")
	
	if slot_info.enemy:
		for i in range(slot_info.amount):
			yield(get_tree().create_timer(.3),"timeout")
			if EnemyManager.add_enemy(slot_info.enemy): 
				slot_info.amount -= 1
				if first_tuto_enemy:
					first_tuto_enemy = false
					var en = EnemyManager.get_first_enemy()
					if en: en.set_tile_pos(4)
			else: break
	else: 
		var en = EnemyManager.get_first_enemy()
		if !en: skip_slot = true
	
	if slot_info.amount>0:
		sl.set_data(slot_info.enemy,slot_info.amount)
		$Tween.interpolate_property(sl,"rect_position",null,sl.rect_position-Vector2(10,55),.3,Tween.TRANS_QUAD,Tween.EASE_IN)
		$Tween.start()
		Effector.show_float_text("No hay espacio!")
		yield(get_tree().create_timer(.4),"timeout")
		WAVE[0] = str(slot_info.amount)+"*"+slot_info.enemy
	else:
		#$Tween.interpolate_property(sl,"rect_position",null,sl.rect_position+Vector2(10,55),.3,Tween.TRANS_QUAD,Tween.EASE_IN)
		$Tween.interpolate_property(sl,"modulate:a",null,0,.3,Tween.TRANS_QUAD,Tween.EASE_IN)
		$Tween.start()
		WAVE.remove(0)
		yield(get_tree().create_timer(.6),"timeout")
		if is_instance_valid(sl):
			$Grid.remove_child(sl)
			sl.queue_free()
		if WAVE.size()>=max_slots: add_slot(WAVE[max_slots-1])
		else: reorder_grid()
	
	if skip_slot: 
		yield(get_tree().create_timer(.6),"timeout")
		advance_wave()
	
	print("************WAVE ",WAVE," ",WAVE.size())
	return true

func add_slot(code):
	var node = WaveSlot.instance()
	var amount = 1
	if code: 
		amount = int( code.substr(0,1) )
		code = code.substr(2,-1) 
	node.set_data(code,amount)
	node.rect_position.x = 6*space_slot
	node.modulate.a = 0
	$Grid.add_child(node)
	reorder_grid()

func reorder_grid():
	for sl in $Grid.get_children():
		var i = sl.get_index()
		var c = 1-i*0.15
		var color = Color(c,c,c,1)
		$Tween.interpolate_property(sl,"rect_position:x",null,i*space_slot,.3,Tween.TRANS_QUAD,Tween.EASE_IN_OUT,i*0.2)
		#$Tween.interpolate_property(sl,"rect_scale",null,Vector2(c,c),.3,Tween.TRANS_QUAD,Tween.EASE_IN_OUT,i*0.2)
		$Tween.interpolate_property(sl,"modulate",null,color,.3,Tween.TRANS_QUAD,Tween.EASE_IN_OUT,i*0.2)
	$Tween.start()

func get_slot_info(code):
	var data = {"enemy":null, "amount":0}
	if code: 
		data.amount = int( code.substr(0,1) )
		data.enemy = code.substr(2,-1) 
	return data
