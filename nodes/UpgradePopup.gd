extends Control

var current_option
var ini_belt_extra_pos
var new_army
var new_army_data
signal on_hide_popup()

func _ready():
	$ButtonCancel.connect("button_down",self,"hide_popup")
	for bs in $HBox.get_children(): bs.connect("on_click_belt_slot",self,"on_click_belt_slot")

func show_popup():
	modulate.a = 0
	update_belt()
	$Label.text = Lang.get_text("ui_end_wave")
	$Label_subtext.text = Lang.get_text("ui_upg_new_army")
	new_army = get_random_new_army()
	new_army_data = ArmyManager.get_army_data(new_army)
	$NewArmyPanel/lb_name.text = Lang.get_text("army_"+new_army_data.name+"_name")
	$NewArmyPanel/lb_amount.text = ""
	if new_army_data.amount>0: $NewArmyPanel/lb_amount.text = "x"+str(new_army_data.amount)
	$NewArmyPanel/lb_desc.text = Lang.get_text("army_"+new_army_data.name+"_desc")
	$NewArmyPanel/Sprite.frame = ArmyManager.ARMIES.find(new_army_data.name)
	Effector.appear($NewArmyPanel)
	if PlayerManager.PLAYER_ARMIES.size()<8:
		var bs = $HBox.get_child(PlayerManager.PLAYER_ARMIES.size())
		bs.set_army(null)
		bs.visible = true
	visible = true
	Effector.appear(self)

func hide_popup():
	Effector.disappear(self,true)
	emit_signal("on_hide_popup")

func update_belt():
	for bs in $HBox.get_children(): 
		bs.modulate.a = 1
		bs.visible = (bs.get_index() < PlayerManager.PLAYER_ARMIES.size())
		if bs.visible: 
			bs.amount = get_node("/root/Game/CLUI/Belt/HBox").get_child(bs.get_index()).amount
			bs.set_army(PlayerManager.PLAYER_ARMIES[bs.get_index()])

func on_click_belt_slot(belt_slot):
	print(PlayerManager.PLAYER_ARMIES," ",belt_slot.get_index())
	Effector.disappear($NewArmyPanel)
	#Effector.move_to($BeltExtra,belt_slot.rect_global_position)
	yield(get_tree().create_timer(.3),"timeout")
	if belt_slot.get_index()==PlayerManager.PLAYER_ARMIES.size():
		PlayerManager.PLAYER_ARMIES.append(new_army)
		belt_slot.set_army(new_army)
		#Effector.disappear(bs)

func get_random_new_army():
	var only_once_armies = ["stake","dynamite"]
	var armies = []
	for i in range(4,ArmyManager.ARMIES.size()):
		var ar = ArmyManager.ARMIES[i]
		if only_once_armies.find(ar)!=-1 && PlayerManager.PLAYER_ARMIES.find(ar)!=-1: continue
		else: armies.append(ar)
	randomize()
	print("ARMIES ",armies)
	return armies[ randi()%armies.size() ]
