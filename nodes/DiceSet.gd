extends Control

var current_dice:Dice
var amount_dices = 2
var six_checked = 0
signal on_click_dice(dice)
signal end_all_rolls()

func _ready():
	for d in $HBoxDices.get_children(): 
		d.connect("on_click_dice",self,"on_click_dice")
	hide_diceset()

func on_click_dice(dice):
	emit_signal("on_click_dice",dice)

func on_dice_result(dice):
	if dice.value==6: 
		Effector.shake(dice)
		yield(get_tree().create_timer(.7),"timeout")
		add_extra_dice().roll()

func show_diceset():
	Effector.appear(self)
	for d in $HBoxDices.get_children():
		if d.get_index()<amount_dices: d.show_dice()

func hide_diceset():
	Effector.disappear(self)
	for d in $HBoxDices.get_children(): 
		d.hide_dice()

func roll_all_dices():
	for d in $HBoxDices.get_children():
		if d.value == -1: d.roll()
	yield(get_tree().create_timer(1.8),"timeout")
	var checked_dices = 0
	while checked_dices<$HBoxDices.get_child_count():
		print("DICE CHECKED ",checked_dices)
		var dice = $HBoxDices.get_child(checked_dices)
		if dice.value==6: 
			#Effector.shake(dice)
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
	return null

func get_and_hide_first_dice_army():
	for d in $HBoxDices.get_children():
		if !d.is_hide and d.army:
			var arm = d.army
			d.hide_dice()
			return arm
	return null
