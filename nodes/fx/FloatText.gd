extends Control

func _ready():
	$Tween.interpolate_property(self,"rect_position",rect_position,rect_position+Vector2(0,-30),1.5,Tween.TRANS_QUAD,Tween.EASE_IN,.5)
	$Tween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),.5,Tween.TRANS_QUAD,Tween.EASE_IN,1.5)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	queue_free()

func set_data(text):
	$Label.text = text
