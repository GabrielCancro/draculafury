extends Control

var upg_data
var active = false
var selected = false

func set_data(upg_code):
	upg_data = UpgradesManager.get_upgrade_data(upg_code)
	$Sprite.frame = upg_data.ico
	$lb_req.text = str(upg_data.lvreq)
	activate(false)
	select(false)

func _ready():
	pass

func activate(val):
	active = val
	$lb_req.visible = !active
	if active: $Sprite.modulate = Color(1,1,1,1)
	else: $Sprite.modulate = Color(0,0,0,1)

func select(val):
	selected = val
	if selected: $Sprite.material = preload("res://assets/sh_outline.tres")
	else: $Sprite.material = null
