extends ColorRect

func _ready(): visible = false

func show_hint(code,req=null):
	$Label.text = Lang.get_text(code)
	$RichTextLabel.bbcode_text = Lang.get_text(code)
	visible = true
	if req: $ReqSlatBar.set_data(req)

func hide_hint():
	visible = false
