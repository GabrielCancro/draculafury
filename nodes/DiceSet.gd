extends Control

var current_dice:Dice
var amount_dices = 2
var six_checked = 0
signal on_click_dice(dice)
signal end_all_rolls()
signal end_dice_part_collect()

func _ready():
	for d in $HBoxDices.get_children(): 
		d.connect("on_click_dice",self,"on_click_dice")
	hide_diceset()

func on_click_dice(dice):
	emit_signal("on_click_dice",dice)

func show_diceset():
	Effector.appear(self)
	for d in $HBoxDices.get_children():
		if d.get_index()<amount_dices: d.show_dice()

func hide_diceset():
	Effector.disappear(self)
	for d in $HBoxDices.get_children(): 
		d.hide_dice()

func get_dice_parts():
	yield(get_tree().create_timer(.2),"timeout")
	for d in $HBoxDices.get_children(): 
		if d.visible: 
			Effector.move_to(d,Vector2(200,200))
			d.hide_dice()
			yield(get_tree().create_timer(.3),"timeout")
			PlayerManager.add_xp(1)
			yield(get_tree().create_timer(.3),"timeout")
	emit_signal("end_dice_part_collect")

func clear_unused_dices():
	yield(get_tree().create_timer(.2),"timeout")
	for d in $HBoxDices.get_children(): 
		if d.visible: 
			yield(get_tree().create_timer(.1),"timeout")
			d.hide_dice()

func roll_all_dices():
	Sounds.play_sound("roll_dices")
	for d in $HBoxDices.get_children():
		if d.value == -1: d.roll()
	yield(get_tree().create_timer(1.8),"timeout")
	var checked_dices = 0
	while checked_dices<$HBoxDices.get_child_count():
		print("DICE CHECKED ",checked_dices)
		var dice = $HBoxDices.get_child(checked_dices)
		if dice.value==6:
			if SaveManager.savedData.level==1:
				get_node("/root/Game/CLUI/TutorialPopup").show_popup("getsix")
				yield(get_node("/root/Game/CLUI/TutorialPopup"),"close_popup")
			Effector.scale_boom(dice)
			yield(get_tree().create_timer(.7),"timeout")
			var new_dice = add_extra_dice()
			if new_dice: new_dice.roll()
			else: checked_dices = 99
			yield(get_tree().create_timer(1.2),"timeout")
		checked_dices += 1
	yield(get_tree().create_timer(1),"timeout")
	emit_signal("end_all_rolls")

func is_all_dices_rolled():
	for d in $HBoxDices.get_children(): if d.value==-1: return false
	return true

func add_extra_dice():
	for d in $HBoxDices.get_children():
		if !d.visible:
			d.show_dice()
			return d
	Effector.show_float_text("ui_max_dices")
	return null

func get_and_hide_first_dice_army():
	for d in $HBoxDices.get_children():
		if !d.is_hide and d.army:
			var arm = d.army
			d.hide_dice()
			return arm
	return null
