extends Control

var current_option
var ini_belt_extra_pos
signal on_hide_popup()

func _ready():
	ini_belt_extra_pos = $BeltExtra.rect_global_position
	$ButtonCancel.connect("button_down",self,"hide_popup")
	$ButtonNewArmy.connect("button_down",self,"on_click_button",["new_army"])
	$ButtonUpgArmy.connect("button_down",self,"on_click_button",["upg_army"])
	for bs in $HBox.get_children(): bs.connect("on_click_belt_slot",self,"on_click_belt_slot")

func show_popup():
	modulate.a = 0
	update_belt()
	$Label.text = Lang.get_text("ui_end_wave")
	$Label_subtext.text = ""
	$BeltExtra.visible = false
	$BeltExtra.modulate.a = 1
	$BeltExtra.rect_global_position = ini_belt_extra_pos
	$ButtonNewArmy.visible = true
	$ButtonUpgArmy.visible = false
	current_option = null
	visible = true
	Effector.appear(self)

func hide_popup():
	Effector.disappear(self,true)
	emit_signal("on_hide_popup")

func update_belt():
	for bs in $HBox.get_children(): 
		bs.modulate.a = 1
		bs.visible = (bs.get_index() < PlayerManager.PLAYER_ARMIES.size())
		if bs.visible: bs.set_army(PlayerManager.PLAYER_ARMIES[bs.get_index()])

func on_click_button(code):
	if code=="upg_army": return
	current_option = code
	$ButtonNewArmy.visible = false
	$ButtonUpgArmy.visible = false
	if code == "new_army": 
		$Label_subtext.text = Lang.get_text("ui_upg_new_army")
		$BeltExtra.set_army( get_random_new_army() )
		$BeltExtra.visible = true
		if PlayerManager.PLAYER_ARMIES.size()<8:
			var bs = $HBox.get_child(PlayerManager.PLAYER_ARMIES.size())
			bs.set_army(null)
			bs.visible = true

func on_click_belt_slot(belt_slot):
	print(PlayerManager.PLAYER_ARMIES," ",belt_slot.get_index())
	if current_option == "new_army":
		current_option = null
		Effector.disappear($BeltExtra)
		Effector.move_to($BeltExtra,belt_slot.rect_global_position)
		yield(get_tree().create_timer(.3),"timeout")
		if belt_slot.get_index()==PlayerManager.PLAYER_ARMIES.size():
			PlayerManager.PLAYER_ARMIES.append($BeltExtra.army)
			belt_slot.set_army($BeltExtra.army)
			#Effector.disappear(bs)
		else:
			PlayerManager.PLAYER_ARMIES[belt_slot.get_index()] = $BeltExtra.army
			belt_slot.set_army($BeltExtra.army)

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
