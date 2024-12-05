extends Node

var POPS = {
	"options":preload("res://nodes/OptionsPopup.tscn"),
}

signal close_popup(code)

func show_popup(code):
	var node = POPS[code].instance()
	node.modulate.a = 0
	get_node("/root").add_child(node)
	Effector.appear(node)
	return node

func hide_popup(node_popup):
	var bm = node_popup.get_node_or_null("blockmouse")
	if bm: bm.visible = true
	Effector.disappear(node_popup)
	yield(get_tree().create_timer(.7),"timeout")
	node_popup.queue_free()
	emit_signal("close_popup")
