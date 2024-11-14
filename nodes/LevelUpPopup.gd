extends ColorRect

signal close_popup()

func _ready():
	$ColorRect/btn.connect("button_down",self,"on_click_ok")
	$ColorRect/lb_desc.text = Lang.get_text("ui_levelup_es")

func show_popup():
	$ColorRect/lb_desc.text = Lang.get_text("win_game")
	modulate.a = 0
	visible = true
	Effector.appear(self)

func on_click_ok():
	Effector.disappear(self,true)
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("close_popup")
