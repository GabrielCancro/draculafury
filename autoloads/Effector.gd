extends Node

var tween = Tween.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(tween)

func appear(node):
	tween.interpolate_property(node,"modulate:a",0,1,.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()

func disappear(node,hide_end=false):
	tween.interpolate_property(node,"modulate:a",null,0,.5,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.start()
	if hide_end:
		yield(get_tree().create_timer(.5),"timeout")
		node.visible = false

func move_to(node,pos):
	tween.interpolate_property(node,"position",null,pos,.3,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()

func shake(node,power=6,time=.5):
	var isControl = ("rect_position" in node)
	var ini_pos
	if isControl: ini_pos = node.rect_position
	else: ini_pos = node.position
	randomize()
	while time>0:
		if !is_instance_valid(node): return
		if isControl: node.rect_position = ini_pos + Vector2(rand_range(-power,power),rand_range(-power/2,power/2))
		else: node.position = ini_pos + Vector2(rand_range(-power,power),rand_range(-power/2,power/2))
		time -= .025
		yield(get_tree().create_timer(.025),"timeout")
	if isControl: node.rect_position = ini_pos
	else: node.position = ini_pos

func blood_bg():
	var blood = get_node("/root/Game/CLBG/blood")
	blood.visible = true
	tween.interpolate_property(blood,"modulate:a",.5,0,.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()

func show_float_text(code):
	var node = preload("res://nodes/fx/FloatText.tscn").instance()
	node.set_float(code)
	get_node("/root/Game/CLUI").add_child(node)

func show_damage_text(val,pos):
	var node = preload("res://nodes/fx/FloatText.tscn").instance()
	node.set_damage(val,pos)
	get_node("/root/Game/CLUI").add_child(node)

func add_hint(node,tx_code):
	node.connect("mouse_entered",self,"_on_hint_enter_area",[node,tx_code,true])
	node.connect("mouse_exited",self,"_on_hint_enter_area",[node,tx_code,false])
	#node.connect("tree_exited",self,"_on_hint_enter_area",[node,tx_code,false])

func _on_hint_enter_area(node,code,val):
	print("HINT: ",node.name,"  ",val)
	if val: get_node("/root/Game/CLUI/HintPanel").show_hint(code)
	else: get_node("/root/Game/CLUI/HintPanel").hide_hint()
