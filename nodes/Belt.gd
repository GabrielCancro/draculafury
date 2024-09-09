extends Control
class_name Belt

var pawn_pos = 1
var max_slots = 5

func _ready():
	$pawn.rect_global_position = $HBox/slot1.rect_global_position
	$ButtonR.connect("button_down",self,"move_pawn",[1])
	$ButtonL.connect("button_down",self,"move_pawn",[-1])

func move_pawn(mov):
	pawn_pos += mov
	if pawn_pos>max_slots: 
		pawn_pos -= max_slots
		$pawn.rect_global_position.x = $HBox.get_child(pawn_pos-1).rect_global_position.x - 80
	if pawn_pos<=0: 
		pawn_pos += max_slots
		$pawn.rect_global_position.x = $HBox.get_child(pawn_pos-1).rect_global_position.x + 80
	var slot_node = $HBox.get_child(pawn_pos-1)
	$Tween.interpolate_property($pawn,"rect_global_position",null,slot_node.rect_global_position,.3,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()
