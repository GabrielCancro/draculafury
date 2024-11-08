extends Node

var used = 0
var points = 3 

var UPGRADES = {
	"upg1":{"name":"life", "ico":0, "state":0},
	"upg2":{"name":"life", "ico":1, "state":0},
	"upg3":{"name":"life", "ico":2, "state":0},
	"upg4":{"name":"life", "ico":0, "state":0},
	"upg5":{"name":"life", "ico":1, "state":-1},
	"upg6":{"name":"life", "ico":2, "state":-1},
	"upg7":{"name":"life", "ico":0, "state":-1},
}

func get_upgrade_data(upg_code):
	var data = {}
	data = UPGRADES[upg_code].duplicate()
	data["code"] = upg_code
	return data
