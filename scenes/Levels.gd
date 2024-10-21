extends Control


func _ready():
	for btn in $Levels.get_children():
		btn.connect("button_down",self,"on_click_level",[btn])
		btn.connect("mouse_entered",self,"on_over",[btn,true])
		btn.connect("mouse_exited",self,"on_over",[btn,false])

func on_click_level(btn):
	var lv = btn.get_index()+1
	if lv<=3:
		LevelManager.goto_level(lv)

func on_over(btn,val):
	$lb_level_name.visible = val
	$lb_level_name.rect_position = btn.rect_position + Vector2(-140,-60)
	$lb_level_name.text = Lang.get_text("level_name_"+str((btn.get_index()+1)))
