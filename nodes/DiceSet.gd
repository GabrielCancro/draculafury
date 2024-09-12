extends Control

var current_dice:Dice
var amount_dices = 2

func _ready():
	restore_all_dices()

func restore_all_dices():
	for d in $HBoxDices.get_children():
		if d.get_index()<amount_dices: d.set_army(null)

func roll_next_dice():
	for d in $HBoxDices.get_children():
		if d.army: continue
		current_dice = d
		current_dice.roll()
		return true
	current_dice = null
	return false

func is_all_dices_rolled():
	for d in $HBoxDices.get_children(): if !d.army and !d.is_hide: return false
	return true

func add_extra_dice():
	for d in $HBoxDices.get_children():
		if d.is_hide:
			d.set_army(null)
			return

func get_and_hide_first_dice_army():
	for d in $HBoxDices.get_children():
		if !d.is_hide and d.army:
			var arm = d.army
			d.hide_dice()
			return arm
	return null
