extends ColorRect

func _ready(): visible = false

func show_hint(hint_data):
	print(hint_data)
	if !hint_data.owner.item_data: return
	var item_data = hint_data.owner.item_data
	$lb_name.text = Lang.get_text("it_"+item_data.code+"_name")
	$lb_desc.text = Lang.get_text("it_"+item_data.code+"_desc")
	$Sprite2.frame = item_data.ico
	if hint_data.owner.rect_position.x<100:
		rect_global_position.x = 200
		rect_global_position.y = hint_data.owner.rect_global_position.y
	else:
		rect_global_position = Vector2(520,300)
	visible = true

func hide_hint():
	visible = false
