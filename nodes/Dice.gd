extends Control
class_name Dice

var value = -1
var blocked = false
signal end_roll(dice)
signal on_click_dice(dice)
var hint_data={"owner":self,"panel":null,"code":null,"over_node":"HintNode","callback":"hint_cb"}


func _ready():
	Effector.add_hint(hint_data)
	randomize()
	value = -1
	$Sprite.frame = 6
	visible = false
	$Button.connect("button_down",self,"on_click")

func show_dice():
	value = -1
	$Sprite.frame = 6
	visible = true
	$Sprite2.modulate.a = 0
	blocked = false
	$Blocker.visible = blocked
	Effector.appear(self)

func on_click():
	if !$HintNode.visible || blocked: return
	Effector.scale_boom(self)
	emit_signal("on_click_dice",self)

func roll():
	if !visible: return
	$Blocker.visible = true
	Effector.show_float_text("roll_dice")
	$Tween.interpolate_property($Sprite,"rotation",0,PI*4,1.2,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()
	for i in range(10):
		$Sprite.frame = randi()%6
		yield(get_tree().create_timer(0.1),"timeout")
	value = $Sprite.frame+1
	yield(get_tree().create_timer(.2),"timeout")
	$Blocker.visible = blocked
	emit_signal("end_roll",self)

func hide_dice():
	print("HIDING DICE ",value)
	if value==-1: return
	value = -1
	$HintNode.visible = false
	Effector.disappear(self,true)

func block_dice():
	blocked = true
	$Blocker.visible = blocked
	Effector.appear($Sprite2)

func hint_cb():
	if $HintNode.visible && value>0:
		get_node("/root/Game/CLUI/Belt").set_shadow_pawn(value)
	else:
		get_node("/root/Game/CLUI/Belt").set_shadow_pawn(0)

func force(val):
	value = val
	$Sprite.frame= value-1
	
