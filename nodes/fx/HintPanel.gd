extends ColorRect

func _ready(): visible = false

func show_hint(code, node):
	$Label.text = Lang.get_text(code)
	$Label/Label.text = Lang.get_text(code)
	$RichTextLabel.bbcode_text = Lang.get_text(code)

	rect_global_position = node.rect_global_position
	rect_global_position.x += node.rect_size.x/2
	if node.rect_global_position.y>300:
		rect_global_position.y -= $Label.rect_size.y + 35
	else:
		rect_global_position.y += node.rect_size.y + 35
	visible = true

func hide_hint():
	visible = false
