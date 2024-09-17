extends Node

signal end_army_action()

var ARMIES = ["breathe","kick","rapier","gun","shotgun","crossbow","stake","dynamite","dynamite","dynamite"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func run_army_action(code):
	Effector.show_float_text("army_"+code)
	var en = EnemyManager.get_first_enemy()
	yield(get_tree().create_timer(.2),"timeout")
	get_node("/root/Game/Player").set_anim(code)
	yield(get_node("/root/Game/Player"),"end_anim")
	if en:
		en.enemy_damage(randi()%5+4)
		yield(get_tree().create_timer(1.0),"timeout")
	emit_signal("end_army_action")
