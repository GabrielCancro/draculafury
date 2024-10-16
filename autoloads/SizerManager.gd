extends Node

var wbase = 1000
func _ready():
	get_tree().root.connect("size_changed", self, "_on_viewport_size_changed")

func _on_viewport_size_changed():
	var scale = 1
	if get_viewport().size.x>wbase: scale = wbase/get_viewport().size.x
	print ("Viewport size changed ",get_viewport().size.x,"  : ",scale)
	
	var ui = get_node_or_null("/root/Game/CLUI/PlayerUI")
	if ui: ui.rect_scale = Vector2(scale,scale)
	ui = get_node_or_null("/root/Game/CLUI/WaveUI")
	if ui: ui.rect_scale = Vector2(scale,scale)
