extends Control

var xpos = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	ArmyManager.ArmyTrapNode = self
	yield(get_tree().create_timer(.5),"timeout")
	set_trap()

func set_trap():
	var arr = []
	var xpos = -1
	randomize()
	for i in range(EnemyManager.max_x_pos-2): arr.append(i+1)
	arr.shuffle()
	arr.append(0)
	arr.append(EnemyManager.max_x_pos-1)
	for i in arr: 
		if EnemyManager.get_enemy_in_pos(i,0): continue
		if i == xpos: continue
		xpos = i
	update_trap()

func update_trap():
	visible = (xpos>=0)
	if visible:
		var grid = get_node("/root/Game/Floor").get_child(xpos)
		rect_position = grid.rect_position
