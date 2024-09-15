extends Node2D

func _ready():
	$Tween.interpolate_property(self,"position",position,position+Vector2(0,-30),1.5,Tween.TRANS_QUAD,Tween.EASE_IN,.5)
	$Tween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),.5,Tween.TRANS_QUAD,Tween.EASE_IN,1.5)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	queue_free()

func set_float(code,style="normal"):
	position = Vector2(1600,900)/2
	if style=="normal":
		$Label.text = Lang.get_text(code)
	if style=="damage":
		$Label.text = str(code)
		$Label.add_color_override("font",Color(1,.5,.5,1))

func set_damage(val,pos):
	position = pos
	scale *= 2
	$Label.text = str(-val)
	$Label.modulate = Color(1,.3,.3,1)
