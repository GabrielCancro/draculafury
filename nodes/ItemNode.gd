extends Control

var item_data = "cruz" #"code":"cruz","ico":1}
var is_infloor = true
var hint_data={"owner":self,"panel":"item","code":"item_none","over_node":"HintNode","callback":null}

signal on_click_item(item_node)

func set_data(_data):
	item_data = _data

func _ready():
	modulate.a = 0
	$SpriteBg.visible = false
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
	if is_infloor:
		is_infloor = false
		ItemManager.reorder_items()
	emit_signal("on_click_item",self)
