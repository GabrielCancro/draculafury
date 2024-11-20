extends Control

var upg_data
var active = false
var selected = false
var SPRITE

func set_data(upg_code):
	if upg_code=="none":
		queue_free()
		return
	upg_data = UpgradesManager.get_upgrade_data(upg_code)
	SPRITE = get_parent()
	#$lb_req.text = str(upg_data.lvreq)
	activate(false)
	select(false)

func _ready():
	set_data(get_parent().name)

func activate(val):
	active = val
	#$lb_req.visible = !active
	if active: SPRITE.modulate = Color(1,1,1,1)
	else: SPRITE.modulate = Color(.2,.2,.2,1)

func select(val):
	selected = val
	if selected: SPRITE.material = preload("res://assets/sh_outline.tres")
	else: SPRITE.material = null
