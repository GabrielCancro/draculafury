extends Control

var WaveSlot = preload("res://nodes/WaveSlot.tscn")
var space_slot = 100
var max_slots = 5

var WAVE = []
var ALL_WAVES = [
	["bat",null,"bat","vampire",null,"bat","vampire"],
	["bat",null,"bat","vampire",null,"bat","vampire"],
	["bat",null,"bat","vampire",null,"bat","vampire"],
	["bat",null,"bat","vampire",null,"bat","vampire"],
	["bat",null,"bat","vampire",null,"bat","vampire"],
	["bat",null,"bat","vampire",null,"bat","vampire"],
	["vampire","vampire","vampire","vampire","vampire","vampire","vampire"],
]

func _ready():
	next_wave()
	yield(get_tree().create_timer(1),"timeout")
	advance_wave()

func next_wave():
	WAVE = ALL_WAVES.pop_front()
	for sl in $Grid.get_children(): 
		$Grid.remove_child(sl)
		sl.queue_free()
	yield(get_tree().create_timer(.5),"timeout")
	for i in range(max_slots): add_slot(WAVE[i])

func advance_wave():
	if WAVE.size()<=0: return false
	var en = WAVE[0] 
	var sl = $Grid.get_child(0)
	if en && !check_free_space(en):
		Effector.shake(sl)
		return false
	WAVE.remove(0)
	$Tween.interpolate_property(sl,"rect_position",null,sl.rect_position+Vector2(60,230),.5,Tween.TRANS_QUAD,Tween.EASE_IN)
	$Tween.interpolate_property(sl,"modulate:a",null,0,.5,Tween.TRANS_QUAD,Tween.EASE_IN)
	$Tween.start()
	yield(get_tree().create_timer(.6),"timeout")
	if en: EnemyManager.add_enemy(en)
	if is_instance_valid(sl):
		$Grid.remove_child(sl)
		sl.queue_free()
	if WAVE.size()>=max_slots: add_slot(WAVE[max_slots-1])
	else: reorder_grid()
	print("************WAVE ",WAVE," ",WAVE.size())
	return true

func add_slot(enemy):
	var node = WaveSlot.instance()
	node.set_data(enemy)
	node.rect_position.x = 6*space_slot
	node.modulate.a = 0
	$Grid.add_child(node)
	reorder_grid()

func reorder_grid():
	for sl in $Grid.get_children():
		var i = sl.get_index()
		var c = 1-i*0.15
		var color = Color(c,c,c,1)
		$Tween.interpolate_property(sl,"rect_position:x",null,i*space_slot,.3,Tween.TRANS_QUAD,Tween.EASE_IN_OUT,i*0.2)
		$Tween.interpolate_property(sl,"modulate",null,color,.3,Tween.TRANS_QUAD,Tween.EASE_IN_OUT,i*0.2)
	$Tween.start()

func check_free_space(en):
	if !en: return false
	var en_data = EnemyManager.get_enemy_data(en)
	if ((en_data.fly && EnemyManager.get_enemy_in_pos(EnemyManager.max_x_pos,1))
	or (!en_data.fly && EnemyManager.get_enemy_in_pos(EnemyManager.max_x_pos,0))):
		Effector.show_float_text("No hay espacio!")
		return false
	return true
