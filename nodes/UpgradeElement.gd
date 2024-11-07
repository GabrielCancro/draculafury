extends Control

var upg_data
var state # -1 unabled, 0/1 selected

func set_data(upg_code):
	upg_data = UpgradesManager.get_upgrade_data(upg_code)
	$Sprite.frame = upg_data.ico
	state = UpgradesManager.UPGRADES[upg_data.code].state
	update_state()

func _ready():
	pass # Replace with function body.

func change_sate(val):
	UpgradesManager.UPGRADES[upg_data.code].state = val
	state = val
	update_state()

func toggle_select():
	if state ==0: change_sate(1)
	elif state ==1: change_sate(0)

func update_state():
	if state != -1: modulate = Color(1,1,1,1)
	else: modulate = Color(.4,.2,.2,1)
	if state == 1: $Sprite.material = preload("res://assets/sh_outline.tres")
	else: $Sprite.material = null
