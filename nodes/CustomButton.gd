extends Button

tool

func _ready():
	focus_mode = Control.FOCUS_NONE
	rect_pivot_offset = rect_size/2
	connect("mouse_entered",self,"on_hover",[true])
	connect("mouse_exited",self,"on_hover",[false])

func _process(delta):
	if $Label.text != text: $Label.text = text

func on_hover(val):
	$Tween.remove_all()
	if val: $Tween.interpolate_property(self, "rect_scale", Vector2(1,1), Vector2(1.1,1.1), .2,Tween.TRANS_QUAD,Tween.EASE_OUT)
	else: $Tween.interpolate_property(self, "rect_scale", Vector2(1.1,1.1), Vector2(1,1), .2,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()
