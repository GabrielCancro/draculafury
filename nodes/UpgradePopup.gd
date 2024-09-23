extends Control

var current_option

func _ready():
	$ButtonCancel.connect("button_down",self,"hide_popup")
	$ButtonNewArmy.connect("button_down",self,"on_click_button",["new_army"])
	$ButtonUpgArmy.connect("button_down",self,"on_click_button",["upg_army"])
	for bs in $HBox.get_children(): bs.connect("on_click_belt_slot",self,"on_click_belt_slot")

func show_popup():
	update_belt()
	$BeltExtra.visible = false
	$ButtonNewArmy.visible = true
	$ButtonUpgArmy.visible = true
	current_option = null
	visible = true

func hide_popup():
	visible = false

func update_belt():
	for bs in $HBox.get_children(): 
		bs.visible = (bs.get_index() < PlayerManager.PLAYER_ARMIES.size())
		if bs.visible: bs.set_army(PlayerManager.PLAYER_ARMIES[bs.get_index()])

func on_click_button(code):
	current_option = code
	$ButtonNewArmy.visible = false
	$ButtonUpgArmy.visible = false
	if code == "new_army": 
		$BeltExtra.set_army( ArmyManager.get_random_army() )
		$BeltExtra.visible = true
		if PlayerManager.PLAYER_ARMIES.size()<8:
			var bs = $HBox.get_child(PlayerManager.PLAYER_ARMIES.size())
			bs.set_army(null)
			bs.visible = true

func on_click_belt_slot(belt_slot):
	print(PlayerManager.PLAYER_ARMIES)
	if current_option == "new_army":
		if belt_slot.get_index()==PlayerManager.PLAYER_ARMIES.size():
			PlayerManager.PLAYER_ARMIES.append($BeltExtra.army)
			var bs = $HBox.get_child(PlayerManager.PLAYER_ARMIES.size())
			Effector.disappear(bs)
		else:
			PlayerManager.PLAYER_ARMIES[belt_slot.get_index()] = $BeltExtra.army
			belt_slot.set_army($BeltExtra.army)
		Effector.disappear($BeltExtra)
		current_option = null
