extends Node

var UPGRADES = {
	"upg1":{"name":"life", "ico":0, "enabled":true, "selected":false},
	"upg2":{"name":"life", "ico":1, "enabled":true, "selected":false},
	"upg3":{"name":"life", "ico":2, "enabled":false, "selected":false},
	"upg4":{"name":"life", "ico":0, "enabled":true, "selected":false},
	"upg5":{"name":"life", "ico":1, "enabled":false, "selected":false},
	"upg6":{"name":"life", "ico":2, "enabled":true, "selected":false},
	"upg7":{"name":"life", "ico":0, "enabled":true, "selected":false},
	"upg8":{"name":"life", "ico":1, "enabled":false, "selected":false},
}

func get_upgrade_data(upg_code):
	var data = {}
	data = UPGRADES[upg_code].duplicate()
	data["code"] = upg_code
	return data
