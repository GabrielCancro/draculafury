extends Control

func _ready():
	SaveManager.load_store_data()
	get_tree().change_scene("res://scenes/Menu.tscn")
