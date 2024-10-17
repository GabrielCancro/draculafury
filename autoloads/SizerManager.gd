extends Node

var gameNodes = ["PlayerUI","WaveUI","HintPanel","HintPanelEnemy","HintPanelArmy","HintPanelItem","TutorialPopup/ColorRect"]
signal on_size_change(scale)

var wbase = 1000
func _ready():
	#get_tree().root.connect("size_changed", self, "rescale_ui")
	rescale_ui(1)
	pass

func rescale_ui(forced=null):
	emit_signal("on_size_change",forced)
#	var scale = 1
#	if get_viewport().size.x>wbase: scale = wbase/get_viewport().size.x
#	if forced: scale = forced
#	print ("Viewport size changed ",get_viewport().size.x,"  : ",scale)
#	get_node_or_null("/root/Game/CLUI/Hacks/LabelScale").text = str(get_viewport().size.x)+"x"+str(get_viewport().size.y)+"  x"+str(forced)
#	for uiname in gameNodes:
#		var ui = get_node_or_null("/root/Game/CLUI/"+uiname)
#		if ui: ui.rect_scale = Vector2(scale,scale)
