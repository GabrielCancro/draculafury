extends Control

var enemy
var amount
var hint_data={"owner":self,"panel":null,"code":null,"over_node":"HintNode","callback":"hint_cb"}

# Called when the node enters the scene tree for the first time.
func _ready():
	Effector.add_hint(hint_data)
	$label.visible = false

func set_data(_enemy,_amount):
	enemy = _enemy
	amount = _amount
	randomize()
	var mask_path = "res://assets/ui/wave_mask_"+str(randi()%3+1)+".png"
	$Sprite.material.set_shader_param("mask", load(mask_path))
	if enemy:
		hint_data.code = "en_"+enemy+"_name"
		$Sprite.texture = load("res://assets/enemies/en_ret_"+enemy+".png")
		#$Sprite2.visible = true
		$lb_amount.visible = true
		$lb_amount.text = "x"+str(amount)
	else:
		$Sprite.texture = load("res://assets/enemies/en_ret_empty.png")
		#$Sprite2.visible = false
		$lb_amount.visible = false

func hint_cb():
	$label.visible = hint_data.is_visible
	if enemy: $label.text = Lang.get_text("en_"+enemy+"_name").to_upper()
	else: $label.text = ""

