extends Control

var army

# Called when the node enters the scene tree for the first time.
func _ready():
	for a in $HBox.get_children():
		a.visible = false

func add_army(_army):
	army = _army
	for ar in $HBox.get_children():
		if !ar.visible:
			ar.modulate.a = 0
			ar.texture = load("res://assets/armies/ar_"+army+".png")
			Effector.appear(ar)
			ar.visible = true
			return
