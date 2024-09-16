extends Control
class_name Dice

var value = -1
var is_hide = true
signal end_roll(value)
signal on_click_dice(dice)

func _ready():
	randomize()
	value = -1
	$Sprite.frame = 6
	$Button.connect("button_down",self,"on_click")

func show_dice():
	value = -1
	$Sprite.frame = 6
	is_hide = false
	Effector.appear(self)

func on_click():
	emit_signal("on_click_dice",self)

func roll():
	if is_hide: return
	Effector.show_float_text("roll_dice")
	$Tween.interpolate_property($Sprite,"rotation",0,PI*4,1.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()
	for i in range(10):
		$Sprite.frame = randi()%6
		yield(get_tree().create_timer(0.1),"timeout")
	value = $Sprite.frame+1
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("end_roll",value)

func hide_dice():
	value = -1
	is_hide = true
	Effector.disappear(self)
