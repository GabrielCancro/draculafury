extends Node

var LAYER
var POPS = {
	"options":load("res://nodes/OptionsPopup.tscn"),
}

signal close_popup(code)

func _ready():
	yield(get_tree().create_timer(.2),"timeout")
	LAYER = CanvasLayer.new()
	LAYER.layer = 2
	get_node("/root").add_child(LAYER)

func show_popup(code):
	var node = POPS[code].instance()
	node.modulate.a = 0
	LAYER.add_child(node)
	Effector.appear(node)
	return node

func hide_popup(node_popup):
	var bm = node_popup.get_node_or_null("blockmouse")
	if bm: bm.visible = true
	Effector.disappear(node_popup)
	yield(get_tree().create_timer(.7),"timeout")
	LAYER.remove_child(node_popup)
	node_popup.queue_free()
	print("REMOVE MODAL!")
	emit_signal("close_popup")
