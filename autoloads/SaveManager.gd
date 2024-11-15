extends Node

var demo = false
var fileName = "user://store_app_data.res"
var savedData = {
	"language":"en",
	"level":1,
	"fullscreen": false
}

func _ready():
	load_store_data()

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
	if(loaded_data): savedData = loaded_data
	else: if("es" in OS.get_locale()): Lang.lang = "es"
	print("LOAD ",savedData)

func now_date():
	var now = OS.get_date() 
	return str(now.year)+"-"+str(now.month)+"-"+str(now.day)

func clear_data():
	var dir = Directory.new()
	dir.remove(fileName)
	get_tree().change_scene("res://scenes/Splash.tscn")
