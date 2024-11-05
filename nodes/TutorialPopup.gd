extends ColorRect

signal close_popup()

func _ready():
	$ColorRect/lb_desc.text = Lang.get_text("tuto_dices")
	$ColorRect/lb_desc2.text = Lang.get_text("tuto_enemies")
	#visible = true
	$ColorRect/ButtonReset.connect("button_down",self,"on_click_ok")

func on_click_ok():
	Effector.disappear(self,true)
	yield(get_tree().create_timer(1),"timeout")
	emit_signal("close_popup")
