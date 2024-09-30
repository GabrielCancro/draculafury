extends ColorRect


func _ready():
	$ButtonReset.connect("button_down",self,"on_click_reset")

func show_popup():
	if visible: return
	modulate.a = 0
	visible = true
	Effector.appear(self)

func on_click_reset():
	get_tree().reload_current_scene()
	
