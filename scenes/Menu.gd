extends Control

func _ready():
	UpgradesManager.upgrades_selected = []
	$btn_start.connect("button_down",self,"on_click",["start"])
	$btn_options.connect("button_down",self,"on_click",["options"])
	$btn_quit.connect("button_down",self,"on_click",["quit"])
	$btn_h1.connect("button_down",self,"on_click",["lvlup"])
	$btn_h2.connect("button_down",self,"on_click",["lvldown"])
	Lang.connect("change_language",self,"localizate")
	localizate()
	Sounds.play_music("menu")

func on_click(val):
	if val=="start":
		if SaveManager.savedData.level>1: Effector.change_scene_transition("Prestart")
		else: Effector.change_scene_transition("Game")
	elif val=="options":
		PopupManager.show_popup("options")
	elif val=="quit":
		get_tree().quit()
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
	$btn_start.text = Lang.get_text("ui_start")
	$btn_options.text = Lang.get_text("ui_options")
	$btn_quit.text = Lang.get_text("ui_quit")
	$lb_level.text = Lang.get_text("ui_level")+" "+str(SaveManager.savedData.level)
