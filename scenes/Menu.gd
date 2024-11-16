extends Control

func _ready():
	$btn1.connect("button_down",self,"on_click",["start"])
	$btn2.connect("button_down",self,"on_click",["lang"])
	$btn3.connect("button_down",self,"on_click",["clear"])
	localizate()
	Sounds.stop_music()

func on_click(val):
	Sounds.play_sound("button1")
	if val=="start":
		if SaveManager.savedData.level>1: get_tree().change_scene("res://scenes/Prestart.tscn")
		else: get_tree().change_scene("res://scenes/Game.tscn")
	elif val=="lang":
		Lang.change_lang()
		localizate()
	elif val=="clear":
		SaveManager.clear_data()

func localizate():
	$btn1/Label.text = Lang.get_text("menu_start")
	$btn2/Label.text = Lang.get_text("menu_lang")
	$lb_level.text = Lang.get_text("ui_level")+" "+str(SaveManager.savedData.level)
