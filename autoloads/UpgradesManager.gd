extends Node

var used = 0
var points = 0 

var UPGRADES = {
	"upg1":{"name":"life", "ico":0, "lvreq":2, "cost":1},
	"upg2":{"name":"life", "ico":1, "lvreq":2, "cost":2},
	"upg3":{"name":"life", "ico":2, "lvreq":3, "cost":1},
	"upg4":{"name":"life", "ico":0, "lvreq":3, "cost":2},
	"upg5":{"name":"life", "ico":1, "lvreq":4, "cost":1},
	"upg6":{"name":"life", "ico":2, "lvreq":4, "cost":1},
	"upg7":{"name":"life", "ico":0, "lvreq":6, "cost":3},
}

func get_upgrade_data(upg_code):
	var data = {}
	data = UPGRADES[upg_code].duplicate()
	data["code"] = upg_code
	return data
