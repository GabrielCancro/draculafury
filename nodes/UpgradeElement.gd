extends Control

var upg_data
var selected

func set_data(upg_code):
	upg_data = UpgradesManager.get_upgrade_data(upg_code)
	$Sprite.frame = upg_data.ico
	selected = UpgradesManager.UPGRADES[upg_data.code].selected
	update_state()

func _ready():
	pass # Replace with function body.

func select(val):
	UpgradesManager.UPGRADES[upg_data.code].selected = val
	selected = val
	update_state()

func toggle_select():
	select(!selected)

func update_state():
	var enabled = UpgradesManager.UPGRADES[upg_data.code].enabled
	if enabled: modulate = Color(1,1,1,1)
	else: modulate = Color(.4,.2,.2,1)
	if selected: $Sprite.material = preload("res://assets/sh_outline.tres")
	else: $Sprite.material = null
