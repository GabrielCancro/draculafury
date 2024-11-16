extends Control

var used_points = 0
var total_points = 0

func _ready():
	$btn1.connect("button_down",self,"on_click_end")
	$btn2.connect("button_down",self,"on_click_back")
	$lb_desc.text = ""
	total_points = SaveManager.savedData.level
	for upg in $Upgrades.get_children(): 
		var upg_code = UpgradesManager.UPGRADES.keys()[upg.get_index()]
		upg.set_data(upg_code)
		var btn = upg.get_node("Button")
		btn.connect("mouse_entered",self,"on_upg_btn",[upg,"enter"])
		btn.connect("mouse_exited",self,"on_upg_btn",[upg,"exit"])
		btn.connect("button_down",self,"on_upg_btn",[upg,"click"])
		if total_points>=upg.upg_data.lvreq: upg.activate(true)
	localizate()
	update_points()

func on_click_end():
	Sounds.play_sound("button1")
	Effector.change_scene_transition("Game")

func on_click_back():
	Sounds.play_sound("button1")
	Effector.change_scene_transition("Menu")

func localizate():
	$lb_title.text = Lang.get_text("prestart_title")
	$btn1/Label.text = Lang.get_text("prestart_end")

func on_upg_btn(upg,val):
	if val=="click" && upg.active:
		Sounds.play_sound("button1") 
		if upg.selected: 
			upg.select(false)
			used_points -= upg.upg_data.cost
		elif total_points-used_points>=upg.upg_data.cost:
			upg.select(true)
			used_points += upg.upg_data.cost
		else: 
			Effector.show_float_text("ui_need_more_points")
			Effector.shake($lb_points)
		update_points()
	if val=="enter": 
		if upg.active: $lb_desc.text = "("+str(upg.upg_data.cost)+") "+Lang.get_text(upg.upg_data.code+"_desc")
		else: $lb_desc.text = Lang.get_text("ui_need_level")
	if val=="exit": $lb_desc.text = ""

func update_points():
	$lb_points.text = str(used_points)+"/"+str(total_points)
