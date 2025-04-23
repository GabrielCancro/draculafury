extends Control

var army
var armies = [null,null,null,null,null,null,null]

# Called when the node enters the scene tree for the first time.
func _ready():
	for a in $HBox.get_children():
		a.get_node("Sprite").visible = false

func add_army(_army,powered=false):
	army = _army
	for ar in $HBox.get_children():
		if !ar.get_node("Sprite").visible:
			if powered: ar.get_node("Sprite").modulate = Color(1,1,0,1)
			else: ar.get_node("Sprite").modulate = Color(1,1,1,1)
			ar.get_node("Sprite").texture = load("res://assets/armies/ico_"+army+".png")
			armies[ar.get_index()] = army
			Effector.appear(ar.get_node("Sprite"))
			ar.get_node("Sprite").visible = true
			return

func is_first_army_powered():
	for ar in $HBox.get_children():
		if ar.get_node("Sprite").visible:
			return (ar.get_node("Sprite").modulate.b<1)
	return false

func get_and_hide_first_army():
	for ar in $HBox.get_children():
		if ar.get_node("Sprite").visible:
			Effector.disappear(ar.get_node("Sprite"),true)
			return armies[ar.get_index()]
	return null

