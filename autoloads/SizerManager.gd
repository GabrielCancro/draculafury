extends Node

var current_scale = 1
var gameNodes = ["PlayerUI","WaveUI","HintPanel","HintPanelEnemy","HintPanelArmy","HintPanelItem","TutorialPopup/ColorRect"]
var wbase = [1100,1300,1500]

func _ready():
	pass
	#for i in range(wbase.size()): wbase[i] *= .5
	#get_tree().root.connect("size_changed", self, "rescale_ui")
	#rescale_ui()

func rescale_ui(forced=null):
	if forced:
		current_scale = forced
	else:
		current_scale = 1
		for i in wbase: if get_viewport().size.x>=i: current_scale -= .1

	print ("Viewport size changed ",get_viewport().size.x,"  : ",current_scale)
	var label = get_node_or_null("/root/Game/CLUI/Hacks/LabelScale")
	if label: label.text = str(get_viewport().size.x)+"x"+str(get_viewport().size.y)+"  x"+str(current_scale)
	for uiname in gameNodes:
		var ui = get_node_or_null("/root/Game/CLUI/"+uiname)
		if ui: ui.rect_scale = Vector2(current_scale,current_scale)
	var game_scene = get_node_or_null("/root/Game")
	if game_scene: ItemManager.reorder_items()
