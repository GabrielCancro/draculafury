extends ColorRect

func _ready(): visible = false

func show_hint(hint_data):
	SizerManager.connect("on_size_change",self,"on_size_change")
	$Label.text = Lang.get_text(hint_data.code)
	$Label/Label.text = Lang.get_text(hint_data.code)
	$RichTextLabel.bbcode_text = Lang.get_text(hint_data.code)

	rect_global_position = hint_data.owner.rect_global_position
	rect_global_position.x += hint_data.owner.rect_size.x/2
	if hint_data.owner.rect_global_position.y>300:
		rect_global_position.y -= $Label.rect_size.y + 35
	else:
		rect_global_position.y += hint_data.owner.rect_size.y + 35
	visible = true

func hide_hint():
	visible = false

func on_size_change(scale):
	rect_scale = Vector2(scale,scale)
