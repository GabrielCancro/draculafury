extends Control

var item_data #"code":"cruz","ico":1}
var is_infloor = true
var hint_data={"owner":self,"panel":"item","code":"item_none","over_node":"HintNode","callback":null}

signal on_click_item(item_node)

func set_data(_data):
	item_data = _data
	$Sprite.frame = item_data.ico

func _ready():
	modulate.a = 0
	$Button.connect("button_down",self,"on_click")
	hint_data.code = "item_"+item_data.code
	Effector.add_hint(hint_data)
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

func on_click():
	print("ITEM CLICK ",item_data.code)
	emit_signal("on_click_item",self)
	if is_infloor: 
		ItemManager.take_item(self)
	else: 
		var GAME = get_node("/root/Game")
		if GAME.current_state!=GAME.GameState.ACTIONS:
			Effector.show_float_text("ui_no_item_face")
			return
		$Button.disabled = true
		rect_size = Vector2(0,0)
		move_to_pos(rect_position+Vector2(50,0))
		ItemManager.run_item_action(item_data.code)
		var result = yield(ItemManager,"end_item_action")
		yield(get_tree().create_timer(.5),"timeout")
		if result:
			move_to_pos(rect_position+Vector2(50,0))
			Effector.disappear(self)
			yield(get_tree().create_timer(.5),"timeout")
			ItemManager.ITEMS_PLAYER.erase(self)
			queue_free()
			yield(get_tree().create_timer(.5),"timeout")
			ItemManager.reorder_items()
		else:
			move_to_pos(rect_position+Vector2(-50,0))
			$Button.disabled = false
			rect_size = Vector2(100,100)
