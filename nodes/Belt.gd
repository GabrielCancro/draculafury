extends Control
class_name Belt

var pawn_pos = 1
var max_slots = 0
var current_slot

signal end_move(army_index)

func _ready():
	$pawn.rect_global_position = $HBox.get_child(0).rect_global_position
	$ButtonR.connect("button_down",self,"move_pawn",[3])
	$ButtonL.connect("button_down",self,"move_pawn",[-1])
	update_belt()
	yield(get_tree().create_timer(.1),"timeout")
	$pawn.rect_global_position = $HBox/BeltSlot1.rect_global_position

func update_belt():
	max_slots = PlayerManager.PLAYER_ARMIES.size()
	for bs in $HBox.get_children(): 
		bs.visible = (bs.get_index() < max_slots)
		if bs.visible: bs.set_army(PlayerManager.PLAYER_ARMIES[bs.get_index()])

func move_pawn(mov):
	pawn_pos += sign(mov)
	if pawn_pos>max_slots: pawn_pos -= max_slots
	if pawn_pos<=0: pawn_pos += max_slots
	var slot_node = $HBox.get_child(pawn_pos-1)
	$Tween.interpolate_property($pawn,"rect_global_position",null,slot_node.rect_global_position,.25,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()
	yield(get_tree().create_timer(.3),"timeout")
	mov -= sign(mov)
	if mov==0: 
		current_slot = slot_node
		current_slot.set_lighted(true)
		emit_signal("end_move",pawn_pos)
	else: move_pawn(mov)

func clear_selected_slot():
	if current_slot: current_slot.set_lighted(false)
