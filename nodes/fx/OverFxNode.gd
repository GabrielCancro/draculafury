extends Control

func _ready():
	modulate.a = 0
	connect("mouse_entered",self,"_on_over_enter_area",[true])
	connect("mouse_exited",self,"_on_over_enter_area",[false])

func _on_over_enter_area(val):
	if val: modulate.a = 1
	else: modulate.a = 0
