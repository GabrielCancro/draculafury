extends Control

func _ready():
	preloads()
	$btn1.connect("button_down",self,"on_click",["start"])
	$btn2.connect("button_down",self,"on_click",["lang"])
	$btn3.connect("button_down",self,"on_click",["clear"])
	$btn_h1.connect("button_down",self,"on_click",["lvlup"])
	$btn_h2.connect("button_down",self,"on_click",["lvldown"])
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
	elif val=="lvlup":
		if SaveManager.savedData.level<10: 
			SaveManager.savedData.level += 1
			SaveManager.save_store_data()
			localizate()
	elif val=="lvldown":
		if SaveManager.savedData.level>1: 
			SaveManager.savedData.level -= 1
			SaveManager.save_store_data()
			localizate()

func localizate():
	$btn1/Label.text = Lang.get_text("menu_start")
	$btn2/Label.text = Lang.get_text("menu_lang")
	$lb_level.text = Lang.get_text("ui_level")+" "+str(SaveManager.savedData.level)

func preloads():
	preload("res://assets/sfx/song1.ogg")
	preload("res://assets/backgrounds/bg1.jpg")
	preload("res://assets/backgrounds/bg2.jpg")
	preload("res://assets/backgrounds/bg3.jpg")
	preload("res://assets/backgrounds/bg4.jpg")
	preload("res://assets/backgrounds/bg5.jpg")
	preload("res://assets/backgrounds/bg6.jpg")
	preload("res://assets/backgrounds/bg7.jpg")
