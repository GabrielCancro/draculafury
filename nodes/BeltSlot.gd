extends Control
class_name BeltSlot

var army
var amount
onready var hint_data={"owner":self,"panel":"army","code":"army_none","over_node":"HintNode","callback":null}

signal on_click_belt_slot(belt_slot)

func _ready():
	$bgselected.visible = false
	$Button.connect("button_down",self,"on_click")
	Effector.add_hint(hint_data)

func set_army(code):
	army = code
	if amount==null: amount = ArmyManager.get_army_amount(army)
	$lb_amount.text = "x"+str(amount)
	$lb_amount.visible = (amount!=-1)
	if army: 
		hint_data.code = "army_"+code
		$Sprite.frame = ArmyManager.ARMIES.find(code)
		$Sprite.visible = true
	else:
		hint_data.code = "army_none"
		$Sprite.visible = false

func set_lighted(val):
	if val:
		Effector.appear($bgselected)
		$bgselected.modulate.a = 0
		$bgselected.visible = true
	else:
		 Effector.disappear($bgselected)

func reduce_amount():
	if amount==-1: return true
	if amount > 0: 
		amount -= 1
		$lb_amount.text = "x"+str(amount)
	else: 
		amount = ArmyManager.get_army_amount(army)
		$panel_reload.visible = false
		$lb_amount.text = "x"+str(amount)
		return false
	if amount == 0: 
		$panel_reload.visible = true
		$lb_amount.text = ""
	return true
	
func on_click():
	print("CLICK ON BELT SLOT ",army)
	emit_signal("on_click_belt_slot",self)
