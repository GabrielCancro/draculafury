extends Control
class_name BeltSlot

var army

func _ready():
	set_army( ArmyManager.ARMIES[get_index()])
	Effector.add_hint($bgcolor,"army_desc_"+army)

func set_army(code):
	army = code
	$Sprite.texture = load("res://assets/armies/ar_"+army+".png")

func set_lighted(val):
	if val:
		Effector.appear($bgselected)
		$bgselected.modulate.a = 0
		$bgselected.visible = true
	else:
		 Effector.disappear($bgselected)
