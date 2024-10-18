extends Control


func _ready():
	for btn in $Levels.get_children():
		btn.connect("button_down",self,"on_click_level",[btn])

func on_click_level(btn):
	var lv = btn.get_index()+1
	if lv==1:
		LevelManager.goto_level(lv)
	
