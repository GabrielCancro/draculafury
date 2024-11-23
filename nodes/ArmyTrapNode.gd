extends Control

var xpos = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	ArmyManager.ArmyTrapNode = self
	yield(get_tree().create_timer(.5),"timeout")
	update_trap()

func update_trap():
	var grid = get_node("/root/Game/Floor").get_child(xpos)
	rect_position = grid.rect_position
