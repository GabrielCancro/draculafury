extends Node

var used = 0
var points = 0 
var upgrades_selected = []

signal end_apply_upgrades()

var UPGRADES = {
	"amulet":{"lvreq":2, "cost":99},
	"bag":{"lvreq":3, "cost":2},
	"map":{"lvreq":3, "cost":2},
	"cigarettes":{"lvreq":3, "cost":99},
	"vest":{"lvreq":4, "cost":1},
	"charger":{"lvreq":4, "cost":99},
	"gunslot":{"lvreq":5, "cost":99},
	"shotgun":{"lvreq":5, "cost":99},
	"silverbullets":{"lvreq":5, "cost":99},
}

func get_upgrade_data(upg_code):
	var data = {}
	data = UPGRADES[upg_code].duplicate()
	data["code"] = upg_code
	return data

func apply_upgrades():
	for upg_code in upgrades_selected: 
		yield(get_tree().create_timer(.5),"timeout")
		if upg_code=="bag":
			ItemManager.throw_random_item()
			yield(get_tree().create_timer(.5),"timeout")
			ItemManager.throw_random_item()
		elif upg_code=="vest":
			PlayerManager.PLAYER_STATS.hpm += 4
			PlayerManager.heal(0)
			yield(get_tree().create_timer(.5),"timeout")
			PlayerManager.heal(4)
		elif upg_code=="map":
			get_node("/root/Game/CLUI/WaveUI").wave_index = 4
		else:
			Effector.show_float_text("upg_"+upg_code+"_name")
			yield(get_tree().create_timer(1),"timeout")
			
	if upgrades_selected.size()>0: yield(get_tree().create_timer(.8),"timeout")
	else: yield(get_tree().create_timer(.1),"timeout")
	emit_signal("end_apply_upgrades")
