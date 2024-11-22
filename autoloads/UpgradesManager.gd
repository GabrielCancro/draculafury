extends Node

var used = 0
var points = 0 
var upgrades_selected = []

signal end_apply_upgrades()

var UPGRADES = {
	"amulet":{"lvreq":2, "cost":2},
	"bag":{"lvreq":3, "cost":3},
	"map":{"lvreq":3, "cost":3},
	"cigarettes":{"lvreq":3, "cost":3},
	"vest":{"lvreq":4, "cost":4},
	"charger":{"lvreq":4, "cost":2},
	"gunslot":{"lvreq":5, "cost":5},
	"shotgun":{"lvreq":5, "cost":5},
	"silverbullets":{"lvreq":5, "cost":5},
}

func get_upgrade_data(upg_code):
	var data = {}
	data = UPGRADES[upg_code].duplicate()
	data["code"] = upg_code
	return data

func have_upgrade(code):
	return (code in upgrades_selected)

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
			get_node("/root/Game/CLUI/WaveUI").wave_index = 3
		elif upg_code=="gunslot":
			PlayerManager.PLAYER_ARMIES.append("gun")
			get_node("/root/Game/CLUI/Belt").update_belt()
		elif upg_code=="shotgun":
			PlayerManager.PLAYER_ARMIES[3] = "shotgun"
			get_node("/root/Game/CLUI/Belt").update_belt()
		else:
			Effector.show_float_text("upg_"+upg_code+"_name")
			yield(get_tree().create_timer(1),"timeout")
			
	if upgrades_selected.size()>0: yield(get_tree().create_timer(.8),"timeout")
	else: yield(get_tree().create_timer(.1),"timeout")
	emit_signal("end_apply_upgrades")
