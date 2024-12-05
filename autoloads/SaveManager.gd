extends Node

var demo = false
var fileName = "user://store_app_data.res"
var savedData = {}

func _ready():
	load_store_data()

func normalize_saved_data():
	var lang_def = "en" if("es" in OS.get_locale()) else "es"
	_default("language","en")
	_default("level",1)
	_default("fullscreen",true)
	save_store_data()

func _default(key,val):
	if !key in savedData: savedData[key] = val

func save_store_data():
	if demo: return
	savedData.language = Lang.lang
	var file = File.new()
	file.open(fileName, File.WRITE)
	file.store_string(var2str(savedData))
	file.close()
	print("SAVE ",savedData)

func load_store_data():    
	if demo: return 
	var file = File.new()
	file.open(fileName, File.READ)
	var loaded_data = str2var(file.get_as_text())
	file.close()
	if loaded_data: savedData = loaded_data
	normalize_saved_data()
	print("LOAD ",savedData)

func now_date():
	var now = OS.get_date() 
	return str(now.year)+"-"+str(now.month)+"-"+str(now.day)

func clear_data():
	savedData = {}
	normalize_saved_data()
	get_tree().change_scene("res://scenes/Splash.tscn")
