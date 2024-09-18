extends Control

var WaveSlot = preload("res://nodes/WaveSlot.tscn")
var space_slot = 100

var WAVE = [
	"bat",null,"bat","vampire",null,
	"bat","vampire",null,"bat","vampire",
	null,null,"bat",null,"bat",
	"vampire",null,"bat","vampire","vampire"
]

func _ready():
	for sl in $Grid.get_children(): 
		$Grid.remove_child(sl)
		sl.queue_free()
	yield(get_tree().create_timer(.5),"timeout")
	for i in range(5): add_slot(WAVE[i])
	yield(get_tree().create_timer(1),"timeout")
	advance_wave()

func advance_wave():
	var en = WAVE.pop_front()
	var sl = $Grid.get_child(0)
	if !check_free_space(en): 
		WAVE.push_front(en)
		Effector.shake(sl)
		return
	
	$Tween.interpolate_property(sl,"rect_position",null,sl.rect_position+Vector2(60,230),.5,Tween.TRANS_QUAD,Tween.EASE_IN)
	$Tween.interpolate_property(sl,"modulate:a",null,0,.5,Tween.TRANS_QUAD,Tween.EASE_IN)
	$Tween.start()
	yield(get_tree().create_timer(.6),"timeout")
	if en: EnemyManager.add_enemy(en)
	if is_instance_valid(sl):
		$Grid.remove_child(sl)
		sl.queue_free()
	add_slot(en)

func add_slot(enemy):
	var node = WaveSlot.instance()
	node.set_data(enemy)
	node.rect_position.x = 6*space_slot
	$Grid.add_child(node)
	reorder_grid()

func reorder_grid():
	for sl in $Grid.get_children():
		var i = sl.get_index()
		var c = 1-i*0.2
		var a = 1-i*0.1
		var color = Color(c,c,c,a)
		print(i)
		$Tween.interpolate_property(sl,"rect_position:x",null,i*space_slot,.3,Tween.TRANS_QUAD,Tween.EASE_IN_OUT,i*0.2)
		$Tween.interpolate_property(sl,"modulate",null,color,.3,Tween.TRANS_QUAD,Tween.EASE_IN_OUT,i*0.2)
	$Tween.start()

func check_free_space(en):
	if !en: return true
	var en_data = EnemyManager.get_enemy_data(en)
	if ((en_data.fly && EnemyManager.get_enemy_in_pos(EnemyManager.max_x_pos,1))
	or (en_data.fly && EnemyManager.get_enemy_in_pos(EnemyManager.max_x_pos,1))):
		Effector.show_float_text("No hay espacio!")
		return false
	return true
