extends Node

signal on_change_stats(player_stats)

var PLAYER_STATS
var PLAYER_ARMIES

func _ready(): initialize_data()

func initialize_data():
	PLAYER_STATS = { "hp":10, "hpm":10, "xp":0, "kills":0}
	PLAYER_ARMIES = ["breathe","gun","kick","trap","rapier"]

func damage(dam):
	PLAYER_STATS.hp = max(PLAYER_STATS.hp-dam,0)
	var player_node = get_node("/root/Game/Player")
	Effector.shake(player_node)
	Effector.blood_bg()
	Sounds.play_hit()
	emit_signal("on_change_stats",PLAYER_STATS)
	if PLAYER_STATS.hp<=0:
		yield(get_tree().create_timer(1),"timeout")
		get_node("/root/Game/CLUI/EndGamePanel").show_popup()

func heal(val):
	PLAYER_STATS.hp = min(PLAYER_STATS.hp+val,PLAYER_STATS.hpm)
	var player_node = get_node("/root/Game/Player")
	#Effector.shake(player_node)
	#Effector.blood_bg()
	emit_signal("on_change_stats",PLAYER_STATS)

func add_xp(val=1):
	Sounds.play_sound("xp")
	PLAYER_STATS.xp += val
	emit_signal("on_change_stats",PLAYER_STATS)

func check_level_up():
	if PLAYER_STATS.xp>=get_next_level_xp():
		yield(get_tree().create_timer(.25),"timeout")
		Effector.show_float_text("msg_level_up")
		var rest = PLAYER_STATS.xp - get_next_level_xp()
		PLAYER_STATS.xp = 0
		emit_signal("on_change_stats",PLAYER_STATS)
		yield(get_tree().create_timer(1.2),"timeout")
		PLAYER_STATS.xp = rest
		SaveManager.savedData.level += 1
		SaveManager.save_store_data()
		emit_signal("on_change_stats",PLAYER_STATS)
		return true

func get_next_level_xp():
	return 4 + SaveManager.savedData.level * 2
