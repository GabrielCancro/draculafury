extends Control
class_name BeltSlot

var army

func _ready():
	$bgselected.visible = false
	set_army( ArmyManager.ARMIES[get_index()])
	Effector.add_hint($bgcolor,"army_desc_"+army)

func set_army(code):
	army = code
	Effector.add_hint(self,"army_"+code)
	$Sprite.frame = ArmyManager.ARMIES.find(code)

func set_lighted(val):
	if val:
		Effector.appear($bgselected)
		$bgselected.modulate.a = 0
		$bgselected.visible = true
	else:
		 Effector.disappear($bgselected)
