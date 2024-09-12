extends Node

var tween = Tween.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(tween)

func appear(node):
	tween.interpolate_property(node,"modulate:a",0,1,.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()

func disappear(node):
	tween.interpolate_property(node,"modulate:a",null,0,.5,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.start()

func move_to(node,pos):
	tween.interpolate_property(node,"position",null,pos,.3,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()

func shake(node,power=2,time=.5):
	var ini_pos = node.position
	randomize()
	while time>0:
		if !is_instance_valid(node): return
		node.position = ini_pos + Vector2(rand_range(-power,power),rand_range(-power/2,power/2))
		time -= .025
		yield(get_tree().create_timer(.025),"timeout")
	node.position = ini_pos

func show_float_text(code):
	var node = preload("res://nodes/fx/FloatText.tscn").instance()
	node.set_data(Lang.get_text(code))
	get_node("/root/Game").add_child(node)

func add_hint(node,tx_code):
	node.connect("mouse_entered",self,"_on_hint_enter_area",[node,tx_code,true])
	node.connect("mouse_exited",self,"_on_hint_enter_area",[node,tx_code,false])
	node.connect("tree_exited",self,"_on_hint_enter_area",[node,tx_code,false])

func _on_hint_enter_area(node,code,val):
	print("HINT: ",node.name,"  ",val)
	if val: get_node("/root/Game/HintPanel").show_hint(code)
	else: get_node("/root/Game/HintPanel").hide_hint()
