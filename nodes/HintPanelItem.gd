extends ColorRect

func _ready(): visible = false

func show_hint(hint_data):
	print(hint_data)
	if !hint_data.owner.item: return 
	var item = hint_data.owner.item
	$lb_name.text = Lang.get_text("it_"+item+"_name")
	$lb_desc.text = Lang.get_text("it_"+item+"_desc")
	#rect_global_position.y = hint_data.owner.rect_global_position.y - 300
	#if rect_global_position.y<100: rect_global_position.y = 100
	visible = true

func hide_hint():
	visible = false
