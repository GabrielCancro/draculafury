extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$btn1.connect("button_down",self,"on_click",["start"])
	$btn2.connect("button_down",self,"on_click",["lang"])
	localizate()

func on_click(val):
	if val=="start":
		get_tree().change_scene("res://scenes/Game.tscn")
	elif val=="lang":
		Lang.change_lang()
		localizate()

func localizate():
	$btn1/Label.text = Lang.get_text("menu_start")
	$btn2/Label.text = Lang.get_text("menu_lang")
