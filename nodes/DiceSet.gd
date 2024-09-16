extends Control

var current_dice:Dice
var amount_dices = 2
signal on_click_dice(dice)
signal end_all_rolls()

func _ready():
	for d in $HBoxDices.get_children(): d.connect("on_click_dice",self,"on_click_dice")
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
	
func roll_all_dices():
	for d in $HBoxDices.get_children():
		if d.value == -1: d.roll()
	yield(get_tree().create_timer(1.5),"timeout")
	emit_signal("end_all_rolls")

func is_all_dices_rolled():
	for d in $HBoxDices.get_children(): if !d.army and !d.is_hide: return false
	return true

func add_extra_dice():
	for d in $HBoxDices.get_children():
		if d.is_hide:
			d.show_dice()
			break

func get_and_hide_first_dice_army():
	for d in $HBoxDices.get_children():
		if !d.is_hide and d.army:
			var arm = d.army
			d.hide_dice()
			return arm
	return null
