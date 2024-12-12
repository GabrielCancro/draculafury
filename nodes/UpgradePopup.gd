extends Control

var current_option
var ini_belt_extra_pos
var new_army
var new_army_data
signal on_hide_popup()

func _ready():
	for bs in $HBox.get_children(): bs.connect("on_click_belt_slot",self,"on_click_belt_slot")
	$Button.connect("button_down",self,"on_click_leave")

func show_popup():
	modulate.a = 0
	get_node("/root/Game/CLUI/HintPanelArmy").rect_global_position.y = 670
	$block.visible = false
	$Button.modulate.a = 0
	update_belt()
	$Label.text = Lang.get_text("ui_end_wave")
	$Label_subtext.text = Lang.get_text("ui_upg_new_army")
	$Button/Label.text = Lang.get_text("ui_dont_hope_army")
	new_army = get_random_new_army()
	new_army_data = ArmyManager.get_army_data(new_army)
	$NewArmyPanel.modulate.a = 0
	$NewArmyPanel/lb_name.text = Lang.get_text("army_"+new_army_data.name+"_name")
	var max_amount = ArmyManager.get_army_amount(new_army_data.name)
	if max_amount!=null: $NewArmyPanel/lb_amount.text = "x"+str(max_amount)
	else: $NewArmyPanel/lb_amount.text = ""
	$NewArmyPanel/lb_desc.text = Lang.get_text("army_"+new_army_data.name+"_desc")
	$NewArmyPanel/Sprite.texture = load("res://assets/armies/arm_"+new_army_data.name+".png")
#	if PlayerManager.PLAYER_ARMIES.size()<8:
#		var bs = $HBox.get_child(PlayerManager.PLAYER_ARMIES.size())
#		bs.set_army(null)
#		bs.visible = true
	visible = true
	Effector.appear(self)
	yield(get_tree().create_timer(1),"timeout")
	Effector.appear($Button)
	Effector.appear($NewArmyPanel)

func hide_popup():
	$Button.modulate.a = 0
	Effector.disappear(self,true)
	get_node("/root/Game/CLUI/HintPanelArmy").rect_global_position.y = 510
	emit_signal("on_hide_popup")

func update_belt():
	for bs in $HBox.get_children(): 
		bs.modulate.a = 1
		bs.visible = (bs.get_index() < PlayerManager.PLAYER_ARMIES.size())
		if bs.visible: 
			bs.amount = get_node("/root/Game/CLUI/Belt/HBox").get_child(bs.get_index()).amount
			bs.set_army(PlayerManager.PLAYER_ARMIES[bs.get_index()])

func on_click_belt_slot(belt_slot):
	Effector.disappear($NewArmyPanel)
	Effector.disappear($Button)
	$Button.modulate.a = 0
	yield(get_tree().create_timer(.3),"timeout")
	belt_slot.amount = null
	belt_slot.set_army(new_army)
	get_node("/root/Game/CLUI/Belt/HBox").get_child(belt_slot.get_index()).amount = belt_slot.amount
	if belt_slot.get_index()==PlayerManager.PLAYER_ARMIES.size(): PlayerManager.PLAYER_ARMIES.append(new_army)
	else: PlayerManager.PLAYER_ARMIES[belt_slot.get_index()] = new_army
	$block.visible = true
	yield(get_tree().create_timer(1.5),"timeout")
	hide_popup()

func get_random_new_army():
	var armies = []
	var wave_index = get_node("/root/Game/CLUI/WaveUI").wave_index
	for army in ArmyManager.ARMIES.keys():
		if PlayerManager.PLAYER_ARMIES.find(army)!=-1: continue
		if army=="stake" && wave_index<=2: continue
		if army=="dynamite" && wave_index<=2: continue
		armies.append(army)
	randomize()
	return armies[ randi()%armies.size() ]

func on_click_leave():
	hide_popup()
