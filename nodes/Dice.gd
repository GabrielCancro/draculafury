extends Control
class_name Dice

var value = 1
var army
var is_hide = true
signal end_roll(value)

func _ready():
	randomize()
	$Army.modulate.a = 0
	$Sprite.modulate.a = 0
	$Sprite.frame = 6
	$Button.connect("button_down",self,"roll")

func roll():
	Effector.show_float_text("roll_dice")
	$Tween.interpolate_property($Sprite,"rotation",0,PI*4,1.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()
	for i in range(10):
		$Sprite.frame = randi()%6
		yield(get_tree().create_timer(0.1),"timeout")
	value = $Sprite.frame+1
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("end_roll",value)

func set_army(code):
	print("SET ARMY ",code)
	army = code
	is_hide = false
	if army: 
		$Army.texture = load("res://assets/armies/ar_"+army+".png")
		Effector.disappear($Sprite)
		yield(get_tree().create_timer(.3),"timeout")
		Effector.appear($Army)
	else:
		$Sprite.frame = 6
		Effector.disappear($Army)
		Effector.appear($Sprite)

func hide_dice():
	is_hide = true
	Effector.disappear($Army)
	Effector.disappear($Sprite)
