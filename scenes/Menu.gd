extends Control


func _ready():
	$btn1.connect("button_down",self,"on_click",["start"])
	$btn2.connect("button_down",self,"on_click",["lang"])
	localizate()

func on_click(val):
	Sounds.play_sound("button1")
	if val=="start":
		if UpgradesManager.points>0: get_tree().change_scene("res://scenes/Prestart.tscn")
		else: get_tree().change_scene("res://scenes/Game.tscn")
	elif val=="lang":
		Lang.change_lang()
		localizate()

func localizate():
	$btn1/Label.text = Lang.get_text("menu_start")
	$btn2/Label.text = Lang.get_text("menu_lang")
