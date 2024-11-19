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
		Effector.show_float_text(upg_code)
		yield(get_tree().create_timer(1),"timeout")
	yield(get_tree().create_timer(.2),"timeout")
	emit_signal("end_apply_upgrades")
