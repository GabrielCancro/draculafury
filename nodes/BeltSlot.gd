extends Control
class_name BeltSlot

var army
var amount
var hint_data={"owner":self,"panel":"army","code":"army_none","over_node":"HintNode","callback":null}

signal on_click_belt_slot(belt_slot)

func _ready():
	$bgselected.visible = false
	$Button.connect("button_down",self,"on_click")
	Effector.add_hint(hint_data)

func set_army(code):
	army = code
	if army: 
		hint_data.code = "army_"+code
		$Sprite.texture = load("res://assets/armies/arm_"+code+".png")
		$Sprite.visible = true
		var max_amount = ArmyManager.get_army_amount(army)
		if max_amount==null: amount = null
		if max_amount!=null && amount==null: amount = max_amount
		$lb_amount.text = "x"+str(amount)
		$lb_amount.visible = (max_amount!=null)
		$panel_reload.visible = (max_amount!=null && amount==0)
	else:
		hint_data.code = "army_none"
		$Sprite.visible = false
		$lb_amount.visible = false
		$panel_reload.visible = false

func set_lighted(val):
	if val:
		Effector.appear($bgselected)
		$bgselected.modulate.a = 0
		$bgselected.visible = true
	else:
		 Effector.disappear($bgselected)

func reduce_amount():
	if amount==null: return true
	if amount > 0: 
		amount -= 1
		$lb_amount.text = "x"+str(amount)
	else: 
		amount = ArmyManager.get_army_amount(army)
		$panel_reload.visible = false
		$lb_amount.text = "x"+str(amount)
		Sounds.play_sound("reload")
		return false
	if amount == 0: 
		$panel_reload.visible = true
		$lb_amount.text = ""
	return true
	
func on_click():
	print("CLICK ON BELT SLOT ",army)
	emit_signal("on_click_belt_slot",self)
