extends ColorRect

func _ready():
	visible = false

func show_hint(hint_data):
	if !hint_data.owner.army: return 
	var army_data = ArmyManager.get_army_data(hint_data.owner.army)
	$lb_name.text = Lang.get_text("army_"+army_data.name+"_name")
	#$lb_amount.text = ""
	if "amount" in army_data && army_data.amount>0: $lb_amount.text = "x"+str(army_data.amount)
	$lb_desc.text = Lang.get_text("army_"+army_data.name+"_desc")
	$ArmyTagList.set_tags(army_data.name)
#	$lb_tags.text = ""
#	if "tags" in army_data: 
#		for tag in army_data.tags: 
#			$lb_tags.text += "<"+tag
#			if tag=="damage": $lb_tags.text += "*"+str(army_data.damage)
#			if tag=="ammunition": $lb_tags.text += "x"+str(army_data.amount)
#			$lb_tags.text += "> "
	#$Sprite.frame = ArmyManager.ARMIES.find(army_data.name)
#	if "rect_global_position" in hint_data.owner: 
#		rect_global_position.y = hint_data.owner.rect_global_position.y - 300
#		if rect_global_position.y<400: rect_global_position.y = 670
#		rect_global_position.x = 850-rect_size.x*rect_scale.x*.5
	visible = true

func hide_hint():
	visible = false
