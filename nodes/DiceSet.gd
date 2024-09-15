extends Control

var current_dice:Dice
var amount_dices = 2
signal on_click_dice(dice)

func _ready():
	for d in $HBoxDices.get_children(): d.connect("on_click_dice",self,"on_click_dice")
	#restore_all_dices()

func on_click_dice(dice):
	emit_signal("on_click_dice",dice)

func restore_all_dices():
	for d in $HBoxDices.get_children():
		if d.get_index()<amount_dices: d.set_army(null)

func roll_all_unrolled_dices():
	for d in $HBoxDices.get_children():
		if !d.army: d.roll()

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
