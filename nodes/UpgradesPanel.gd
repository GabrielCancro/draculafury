extends Control


func _ready():
	Effector.remove_all_children($Grid)
	for upg_code in UpgradesManager.UPGRADES.keys():
		var node = preload("res://nodes/UpgradeElement.tscn").instance()
		node.set_data(upg_code)
		$Grid.add_child(node)
		node.connect("mouse_entered",self,"on_over_upg",[node,true])
		node.connect("mouse_exited",self,"on_over_upg",[node,false])
		node.get_node("Button").connect("button_down",self,"on_click_upg",[node])

func on_over_upg(node,val):
	if val: $lb_desc.text = Lang.get_text("upg_"+node.upg_data.name)
	else: $lb_desc.text = ""

func on_click_upg(node):
	node.toggle_select()
