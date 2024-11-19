extends Node

var used = 0
var points = 0 
var upgrades_selected = []

signal end_apply_upgrades()

var UPGRADES = {
	"amulet":{"ico":0, "lvreq":2, "cost":1},
	"bag":{"ico":1, "lvreq":2, "cost":2},
	"vest":{"ico":2, "lvreq":3, "cost":1},
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
		elif upg_code=="velt":
			PlayerManager.PLAYER_STATS.hpm += 4
			PlayerManager.heal(4)
		else:
			Effector.show_float_text("upg_"+upg_code+"_name")
			yield(get_tree().create_timer(1),"timeout")
	if upgrades_selected.size()>0: yield(get_tree().create_timer(.8),"timeout")
	else: yield(get_tree().create_timer(.1),"timeout")
	emit_signal("end_apply_upgrades")
