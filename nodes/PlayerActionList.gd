extends Control

var army

# Called when the node enters the scene tree for the first time.
func _ready():
	for a in $HBox.get_children():
		a.visible = false

func add_army(_army):
	army = _army
	for a in $HBox.get_children():
		if !a.visible:
			a.texture = load("res://assets/armies/ar_"+army+".png")
			Effector.appear(a)
			a.visible = true
			return
