extends Control
class_name Dice

var value = 1

func _ready():
	randomize()
	$Button.connect("button_down",self,"roll")

func roll():
	$Tween.interpolate_property($Sprite,"rotation",0,PI*4,1.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()
	for i in range(10):
		$Sprite.frame = randi()%6
		yield(get_tree().create_timer(0.1),"timeout")
	value = $Sprite.frame+1
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("end_roll",value)
