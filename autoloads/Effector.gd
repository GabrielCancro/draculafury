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

func shake(node,power=2,time=.5):
	var ini_pos = node.position
	randomize()
	while time>0:
		if !is_instance_valid(node): return
		node.position = ini_pos + Vector2(rand_range(-power,power),rand_range(-power/2,power/2))
		time -= .025
		yield(get_tree().create_timer(.025),"timeout")
	node.position = ini_pos
