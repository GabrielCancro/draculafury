extends Control
class_name Belt

var pawn_pos = 1
var max_slots = 0
var current_slot

signal end_move(army_index)

func _ready():
	$pawn/AnimationPlayer.play("idle")
	update_belt()
	set_shadow_pawn(0)
	current_slot = $HBox.get_child(0)

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
	Sounds.play_sound("pawn1")
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
	var pos = (pawn_pos+val-1)%max_slots
	$pawn2.rect_global_position = $HBox.get_child(pos).rect_global_position

func rotate_belt():
	if $pawn.modulate.a<1: return
	Sounds.play_sound("pawn1")
	var dist = $HBox/BeltSlot1.rect_size.x
	$HBox.rect_global_position.x -= 70
	$pawn.modulate.a = 0
	var amounts = []
	for i in range(max_slots): amounts.append($HBox.get_child(0).amount)
	var a = amounts.pop_back()
	amounts.push_front(a)
	for i in range(max_slots): $HBox.get_child(0).amount = amounts[i]
	var end = PlayerManager.PLAYER_ARMIES.pop_back()
	PlayerManager.PLAYER_ARMIES.push_front(end)
	update_belt()
	Effector.move_to($HBox, $HBox.rect_global_position+Vector2(70,0))
	Sounds.play_sound("move_belt")
	yield(get_tree().create_timer(.3),"timeout")
	$pawn.rect_global_position = $HBox.get_child(pawn_pos-1).rect_global_position
	$pawn.modulate.a = 1
