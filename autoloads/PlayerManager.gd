extends Node

signal on_change_stats(player_stats)

var PLAYER_STATS
var PLAYER_ARMIES

func _ready(): initialize_data()

func initialize_data():
	PLAYER_STATS = { "hp":10, "hpm":10, "xp":0,}
	PLAYER_ARMIES = ["breathe","gun","kick","gun","rapier"]

func damage(dam):
	PLAYER_STATS.hp = max(PLAYER_STATS.hp-dam,0)
	var player_node = get_node("/root/Game/Player")
	Effector.shake(player_node)
	Effector.blood_bg()
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
	PLAYER_STATS.xp += val
	if PLAYER_STATS.xp>=10:
		emit_signal("on_change_stats",PLAYER_STATS)
		yield(get_tree().create_timer(1),"timeout")
		Effector.show_float_text("level_up")
		yield(get_tree().create_timer(1),"timeout")
		Effector.show_float_text("extra_dice")
		get_node("/root/Game/CLUI/DiceSet").amount_dices += 1
		PLAYER_STATS.xp -= 10
	emit_signal("on_change_stats",PLAYER_STATS)
