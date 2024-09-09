extends Control
class_name Belt

var pawn_pos = 1
var max_slots = 5
signal end_move(army_index)
signal end_action()

func _ready():
	$pawn.rect_global_position = $HBox.get_child(0).rect_global_position
	$ButtonR.connect("button_down",self,"move_pawn",[3])
	$ButtonL.connect("button_down",self,"move_pawn",[-1])

func move_pawn(mov):
	pawn_pos += sign(mov)
	if pawn_pos>max_slots: pawn_pos -= max_slots
	if pawn_pos<=0: pawn_pos += max_slots
	var slot_node = $HBox.get_child(pawn_pos-1)
	$Tween.interpolate_property($pawn,"rect_global_position",null,slot_node.rect_global_position,.25,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()
	yield(get_tree().create_timer(.3),"timeout")
	mov -= sign(mov)
	if mov==0: emit_signal("end_move",pawn_pos)
	else: move_pawn(mov)

func run_action():
	var slot_node = $HBox.get_child(pawn_pos-1)
	$Tween.interpolate_property(slot_node,"modulate:a",0,1,1,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.interpolate_property(slot_node,"rect_scale:y",1.2,1,1,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()
	yield(get_tree().create_timer(1,5),"timeout")
	emit_signal("end_action")
