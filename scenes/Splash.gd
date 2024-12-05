extends Control

func _ready():
	SaveManager.load_store_data()
	OS.window_fullscreen = SaveManager.savedData.fullscreen
	get_tree().change_scene("res://scenes/Menu.tscn")
