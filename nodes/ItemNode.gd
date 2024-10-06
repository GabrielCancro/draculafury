extends Control

var item = "cruz"
var hint_data={"owner":self,"panel":"item","code":"item_none","over_node":"HintNode","callback":null}

signal on_click_item(item)

func _ready():
	$SpriteBg.visible = false
	$Button.connect("button_down",self,"on_click")
	Effector.add_hint(hint_data)
	#$AnimationPlayer.play("floor")

func on_click():
	print("ITEM CLICK ",item)
