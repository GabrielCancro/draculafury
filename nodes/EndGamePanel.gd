extends ColorRect


func _ready():
	$ButtonReset.connect("button_down",self,"on_click_reset")

func show_popup():
	if visible: return
	modulate.a = 0
	visible = true
	Effector.appear(self)

func on_click_reset():
	Effector.change_scene_transition("Menu")
	
