extends Control

var xpos = -1
var powered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ArmyManager.ArmyTrapNode = self
	modulate.a = 0
	yield(get_tree().create_timer(.5),"timeout")
	update_trap()

func unset_trap():
	powered = false
	xpos = -1
	Effector.disappear(self)
	update_trap()

func set_trap(_powered=false):
	powered = _powered
	var arr = []
	xpos = -1
	randomize()
	for i in range(EnemyManager.max_x_pos-2): arr.append(i+1)
	arr.shuffle()
	arr.append(0)
	arr.append(EnemyManager.max_x_pos-1)
	for i in arr: 
		if EnemyManager.get_enemy_in_pos(i,0): continue
		if i == xpos: continue
		xpos = i
		Effector.appear(self)
		break
	update_trap()

func update_trap():
	visible = (xpos>=0)
	if visible:
		var grid = get_node("/root/Game/Floor").get_child(xpos)
		rect_position = grid.rect_position
