extends Control

var current_dice:Dice
var amount_dices = 2

func _ready():
	reset_all_dices()

func reset_all_dices():
	for d in $HBoxDices.get_children():
		if !d.is_hide: d.hide_dice()
	yield(get_tree().create_timer(.7),"timeout")
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
	for d in $HBoxDices.get_children(): if !d.army and d.visible: return false
	return true

func add_extra_dice():
	for d in $HBoxDices.get_children():
		if !d.visible:
			d.set_army(null)
			d.visible = true
			return
