extends Control

var WaveSlot = preload("res://nodes/WaveSlot.tscn")

var WAVE = [
	"bat",null,"bat","vampire",null,
	"bat","vampire",null,"bat","vampire",
	null,null,"bat",null,"bat",
	"vampire",null,"bat","vampire","vampire"
]

func _ready():
	advance_wave()
	advance_wave()
	for sl in $Grid.get_children(): 
		$Grid.remove_child(sl)
		sl.queue_free()
	for i in range(5): add_slot(WAVE[i])

func advance_wave():
	var en = WAVE.pop_front()
	update_wave()
	if en: EnemyManager.add_enemy(en)
	
	var sl = $Grid.get_child(0)
	$Grid.remove_child(sl)
	sl.queue_free()
	if en: add_slot(en)

func update_wave():
	for slot in $HBoxContainer.get_children(): 
		if slot.get_index()>=WAVE.size():
			slot.set_data(null)
		else:
			slot.set_data( WAVE[slot.get_index()] )

func add_slot(enemy):
	var node = WaveSlot.instance()
	node.set_data(enemy)
	$Grid.add_child(node)
	reorder_grid()

func reorder_grid():
	for sl in $Grid.get_children():
		sl.rect_position.x = sl.get_index()*120
