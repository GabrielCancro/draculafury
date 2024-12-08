extends Control

var WaveSlot = preload("res://nodes/WaveSlot.tscn")
var space_slot = 105
var max_slots = 3
var wave_index = 0
var current_bg = "tomb"

var first_tuto_enemy 

signal end_wave_anim()

var WAVE = []
var ALL_WAVES = [
	["1*dracula",null,"1*vampire",null,"1*vampire"],
	["1*vampire",null,"1*vampire",null,"1*vampire"],  #1
	["2*vampire",null,null,"2*bat"],
	["1*bat",null,"1*bat","1*vampire",null,"2*bat"],
	["1*bat","1*gargoyle","1*vampire",null,"1*vampire"],  #4
	["2*vampire",null,"1*gargoyle","2*bat"],
	["3*bat",null,null,"1*vampire",null,"2*bat"],
	["1*bat",null,"1*gargoyle",null,"1*gargoyle",null,"2*bat"],
	["1*wolf",null,"2*wolf","1*bat","1*vampire"],   #8
	["1*vampire","1*wolf",null,"1*awolf",null,null,"2*bat"],
	["1*vampire",null,"2*wolf","1*bat","1*vampire"],
	["1*vampire","1*wolf",null,"1*awolf",null,"1*bat"],
	["3*wolf",null,null,"2*wolf",null,null,null,"3*wolf"],#12
]

func _ready():
	$lb_wave.text = ""
	Effector.remove_all_children($Grid)

func next_wave():
	wave_index += 1
	check_bg()
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
	
	if slot_info.enemy && slot_info.enemy=="dracula": 
		var draculapopup = get_node("/root/Game/CLUI/DraculaPopup")
		draculapopup.show_popup()
		yield(draculapopup,"close_popup")
	
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

func check_bg():
	if current_bg!="forest" && wave_index>=8: change_bg("forest")
	elif current_bg!="catedral" && wave_index>=4: change_bg("catedral")
	elif current_bg!="tomb": change_bg("tomb")

func change_bg(code):
	preload("res://assets/backgrounds/bg_tomb.jpg")
	preload("res://assets/backgrounds/bg_catedral.jpg")
	preload("res://assets/backgrounds/bg_forest.jpg")
	var bg = "tomb"
	if wave_index>=4: bg = "catedral"
	if wave_index>=8: bg = "forest"
	if current_bg != bg:
		current_bg = bg
		var bgnode = get_node("/root/Game/CLBG/background")
		Effector.fade_yoyo(bgnode)
		yield(get_tree().create_timer(.25),"timeout")
		bgnode.texture = load("res://assets/backgrounds/bg_"+code+".jpg")

func add_dracula_to_wave():
	if WAVE.size()<=2:
		WAVE.append("1*dracula")
		add_slot("1*dracula")
	else:
		WAVE[2] = "1*dracula"
		var sl = $Grid.get_child(2)
		sl.set_data("dracula",1)
