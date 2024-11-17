extends Control

var time = .5
signal end_transition()

func show_transition():
	var node = $CanvasLayer/TextureRect2
	node.modulate.a = 0
	$Tween.interpolate_property(node,"modulate:a",0,1,time,Tween.TRANS_QUAD,Tween.EASE_IN)
	$Tween.start()
	yield(get_tree().create_timer(time+.5),"timeout")
	emit_signal("end_transition")

func hide_transition(remove_end = false):
	var node = $CanvasLayer/TextureRect2
	$Tween.interpolate_property(node,"modulate:a",1,0,time,Tween.TRANS_QUAD,Tween.EASE_IN)
	$Tween.start()
	yield(get_tree().create_timer(time+.05),"timeout")
	emit_signal("end_transition")
	if remove_end: queue_free()
