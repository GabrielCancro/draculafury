extends Control

func _ready():
	UpgradesManager.upgrades_selected = []
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
		if SaveManager.savedData.level>1: Effector.change_scene_transition("Prestart")
		else: Effector.change_scene_transition("Game")
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
