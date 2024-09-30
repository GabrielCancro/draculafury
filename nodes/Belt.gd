extends Control
class_name Belt

var pawn_pos = 1
var max_slots = 0
var current_slot

signal end_move(army_index)

func _ready():
	update_belt()
	$pawn/AnimationPlayer.play("idle")
	set_shadow_pawn(0)

func update_belt():
	max_slots = PlayerManager.PLAYER_ARMIES.size()
	for bs in $HBox.get_children(): 
		bs.visible = (bs.get_index() < max_slots)
		if bs.visible: bs.set_army(PlayerManager.PLAYER_ARMIES[bs.get_index()])
	yield(get_tree().create_timer(.05),"timeout")
	$pawn.rect_global_position = $HBox.get_child(pawn_pos-1).rect_global_position

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

func set_shadow_pawn(val=0):
	$pawn2.visible = (val!=0)
	var pos = pawn_pos+val
	if pos>max_slots: pos -= max_slots
	if pos<0: pos += max_slots
	$pawn2.rect_global_position = $HBox.get_child(pos-1).rect_global_position
