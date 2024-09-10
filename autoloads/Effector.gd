extends Node

var tween = Tween.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(tween)

func appear(node):
	tween.interpolate_property(node,"modulate:a",0,1,.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()

func move_to(node,pos):
	tween.interpolate_property(node,"position",null,pos,.3,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()
