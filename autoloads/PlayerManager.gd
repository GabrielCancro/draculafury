extends Node

signal on_change_stats(player_stats)

var PLAYER_STATS = {
	"hp":10,
	"hpm":10,
	"xp":0,
}

var PLAYER_ARMIES = ["breathe","kick","breathe","rapier","gun"]

func _ready():
	pass

func damage(dam):
	PLAYER_STATS.hp = max(PLAYER_STATS.hp-dam,0)
	var player_node = get_node("/root/Game/Player")
	Effector.shake(player_node)
	Effector.blood_bg()
	emit_signal("on_change_stats",PLAYER_STATS)

func heal(val):
	PLAYER_STATS.hp = min(PLAYER_STATS.hp+val,PLAYER_STATS.hpm)
	var player_node = get_node("/root/Game/Player")
	#Effector.shake(player_node)
	#Effector.blood_bg()
	emit_signal("on_change_stats",PLAYER_STATS)

func add_xp(val=1):
	PLAYER_STATS.xp += val
	if PLAYER_STATS.xp>10: 
		PLAYER_STATS.xp -= 10
	emit_signal("on_change_stats",PLAYER_STATS)
