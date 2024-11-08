extends Control

func _ready():
	$btn1.connect("button_down",self,"on_click_end")
	$lb_desc.text = ""
	for upg in $Upgrades.get_children(): 
		var upg_code = UpgradesManager.UPGRADES.keys()[upg.get_index()]
		upg.set_data(upg_code)
		var btn = upg.get_node("Button")
		btn.connect("mouse_entered",self,"on_upg_btn",[upg,"enter"])
		btn.connect("mouse_exited",self,"on_upg_btn",[upg,"exit"])
		btn.connect("button_down",self,"on_upg_btn",[upg,"click"])
	for upg in UpgradesManager.UPGRADES: 
		if UpgradesManager.UPGRADES[upg].state==1: UpgradesManager.UPGRADES[upg].state = 0
	UpgradesManager.used = 0
	localizate()
	update_points()

func on_click_end():
	get_tree().change_scene("res://scenes/Game.tscn")

func localizate():
	$lb_title.text = Lang.get_text("prestart_title")
	$btn1/Label.text = Lang.get_text("prestart_end")

func on_upg_btn(upg,val):
	if val=="click": 
		upg.toggle_select()
		update_points()
	if upg.state!=-1 && val=="enter": $lb_desc.text = Lang.get_text(upg.upg_data.code+"_desc")
	if val=="exit": $lb_desc.text = ""

func update_points():
	$lb_points.text = str(UpgradesManager.used)+"/"+str(UpgradesManager.points)
