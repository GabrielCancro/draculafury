extends Control

signal close_popup()

func _ready():
	$btn_quit.connect("button_down",self,"on_click",["back"])
	$btn_lang.connect("button_down",self,"on_click",["lang"])
	$btn_clear.connect("button_down",self,"on_click",["clear"])
	$btn_fullscreen.connect("button_down",self,"on_click",["fullscreen"])
	Lang.connect("change_language",self,"localizate")
	localizate()

func localizate():
	$lb_title.text = Lang.get_text("ui_options")
	$btn_quit.text = Lang.get_text("ui_back")
	$btn_lang.text = Lang.get_text("ui_lang_option")
	$btn_clear.text = Lang.get_text("ui_clear_data")
	$btn_fullscreen.text = Lang.get_text("ui_fullscreen")

func on_click(code):
	if code=="back":
		PopupManager.hide_popup(self)
	elif code=="lang":
		Lang.change_lang()
	elif code=="fullscreen":
		SaveManager.savedData.fullscreen != SaveManager.savedData.fullscreen
		SaveManager.save_store_data()
		OS.window_fullscreen = SaveManager.savedData.fullscreen
	elif code=="clear":
		SaveManager.clear_data()
