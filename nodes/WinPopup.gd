extends ColorRect

func _ready():
	$ColorRect/ButtonReset.connect("button_down",self,"on_click_ok")

func show_popup():
	$ColorRect/lb_desc.text = Lang.get_text("win_game")
	modulate.a = 0
	visible = true
	Effector.appear(self)

func on_click_ok():
	Effector.disappear(self,true)
	yield(get_tree().create_timer(1),"timeout")
	get_tree().change_scene("res://scenes/Levels.tscn")
