extends Control

var item_data #"code":"cruz","ico":1}
var is_infloor = true
var fly_ttl = 0
var hint_data={"owner":self,"panel":null,"code":null,"over_node":"HintNode","callback":null}

signal on_click_item(item_node)

func set_data(_data):
	item_data = _data
	$Sprite.frame = item_data.ico
	$HintNode.frame = item_data.ico
	#$Sprite.z_index = 150

func _ready():
	modulate.a = 0
	$HintNode.visible = false
	$Button.connect("button_down",self,"on_click")
	fall_anim()

func fall_anim():
	var t = .6
	randomize()
	var from = rect_position + Vector2(-150,-50)
	var to = rect_position
	to.x += rand_range(-150,50)
	$Tween.interpolate_property(self,"modulate:a",null,1,t*.2,Tween.TRANS_QUAD)
	$Tween.interpolate_property(self,"rect_position:x",from.x,to.x,t,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.interpolate_property(self,"rect_position:y",from.y,from.y-35,t*.40,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.interpolate_property(self,"rect_position:y",from.y-35,to.y,t*.60,Tween.TRANS_QUAD,Tween.EASE_IN,t*.40)
	$Tween.start()

func move_to_pos(pos):
	$Tween.interpolate_property(self,"rect_position",null,pos,.3,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()

func _process(delta):
	fly_ttl += delta*4
	rect_position.y += sin(fly_ttl)*0.3

func on_click():
	if !is_infloor &&!$HintNode.visible: return
	print("ITEM CLICK ",item_data.code)
	emit_signal("on_click_item",self)
	if is_infloor: 
		set_process(false)
		ItemManager.take_item(self)
		hint_data.code = "item_"+item_data.code
		Effector.add_hint(hint_data)
	else: 
		var GAME = get_node("/root/Game")
		if GAME.current_state!=GAME.GameState.ACTIONS:
			Effector.show_float_text("ui_no_item_face")
		else:
			get_node("/root/Game/CLUI/HintPanelItem").show_hint(hint_data)
		return
		

func on_use_item():
	$Button.disabled = true
	rect_size = Vector2(0,0)
	move_to_pos(rect_position+Vector2(0,50))
	ItemManager.run_item_action(item_data.code)
	var result = yield(ItemManager,"end_item_action")
	yield(get_tree().create_timer(.5),"timeout")
	if result:
		move_to_pos(rect_position+Vector2(0,50))
		Effector.disappear(self)
		yield(get_tree().create_timer(.5),"timeout")
		ItemManager.ITEMS_PLAYER.erase(self)
		ItemManager.reorder_items()
		queue_free()
	else:
		move_to_pos(rect_position+Vector2(0,-50))
		$Button.disabled = false
		rect_size = Vector2(100,100)

func on_discard():
	ItemManager.throw_item(item_data.code, 600)
	ItemManager.ITEMS_PLAYER.erase(self)
	queue_free()
	ItemManager.reorder_items()
