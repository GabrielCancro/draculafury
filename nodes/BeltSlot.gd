extends Control
class_name BeltSlot

var army
signal on_click_belt_slot(belt_slot)

func _ready():
	$bgselected.visible = false
	$Button.connect("button_down",self,"on_click")

func set_army(code):
	army = code
	if army: 
		Effector.add_hint(self,"army_"+code)
		$Sprite.frame = ArmyManager.ARMIES.find(code)
		$Sprite.visible = true
	else:
		Effector.add_hint(self,"army_none")
		$Sprite.visible = false

func set_lighted(val):
	if val:
		Effector.appear($bgselected)
		$bgselected.modulate.a = 0
		$bgselected.visible = true
	else:
		 Effector.disappear($bgselected)

func on_click():
	print("CLICK ON BELT SLOT ",army)
	emit_signal("on_click_belt_slot",self)
