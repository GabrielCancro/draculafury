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
		hint_data.code = code
		if get_index()==2: hint_data.code = code+"_pow"
		$Sprite.texture = load("res://assets/armies/arm_"+code+".png")
		$panel_reload/Sprite2.texture = load("res://assets/armies/arm_"+code+".png")
		$Sprite.visible = true
		var max_amount = ArmyManager.get_army_amount(army)
		if max_amount==null: amount = null
		if max_amount!=null && amount==null: amount = max_amount
		$ammunition/Label.text = str(amount)
		$ammunition.visible = (max_amount!=null && amount!=0)
		$panel_reload.visible = (max_amount!=null && amount==0)
	else:
		hint_data.code = "army_none"
		$Sprite.visible = false
		$ammunition.visible = false
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
		$ammunition/Label.text = str(amount)
	else: 
		amount = ArmyManager.get_army_amount(army)
		$panel_reload.visible = false
		$ammunition/Label.text = str(amount)
		$ammunition.visible = true
		Sounds.play_sound("reload")
		return false
	if amount == 0: 
		$panel_reload.visible = true
		$ammunition.visible = false
		$ammunition/Label.text = ""
	return true

func update_amount():
	pass


func on_click():
	print("CLICK ON BELT SLOT ",army)
	emit_signal("on_click_belt_slot",self)
