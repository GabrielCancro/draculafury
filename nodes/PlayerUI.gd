extends Control

var hint_data={"owner":self,"panel":null,"code":null,"over_node":"HintNode","callback":"hint_cb"}

# Called when the node enters the scene tree for the first time.
func _ready():
	Effector.add_hint(hint_data)
	PlayerManager.connect("on_change_stats",self,"update_stats")
	hint_cb()

func update_stats(ps):
	$lb_level.text = Lang.get_text("ui_level")+" "+str(SaveManager.savedData.level)
	$HPBar.max_value = ps.hpm*100
	$XPBar.max_value = PlayerManager.get_next_level_xp()*100
#	for d in $HBoxDiceParts.get_children(): d.visible = (d.get_index()<ps.dice_parts)
	$Tween.remove_all()
	$Tween.interpolate_property($HPBar,"value",null,ps.hp*100,.3,Tween.TRANS_QUAD,Tween.EASE_IN)
	$Tween.interpolate_property($XPBar,"value",null,ps.xp*100,.3,Tween.TRANS_QUAD,Tween.EASE_IN)
	if $HPBar.value != ps.hp*100: Effector.scale_boom($HeartImg)
	$Tween.start()
#	for xp in $XPHBox.get_children():
#		if(xp.get_index()<ps.xp): xp.modulate = Color(1,1,1,1)
#		else: xp.modulate = Color(.3,.3,.3,1)

func hint_cb():
	$label.visible = $HintNode.visible
	$label2.visible = $HintNode.visible
	$lb_level.visible = $HintNode.visible
#	$label3.visible = ($HintNode.visible && PlayerManager.PLAYER_STATS.dice_parts>0)
	$label.text = "HP: " + str(PlayerManager.PLAYER_STATS.hp) + "/" + str(PlayerManager.PLAYER_STATS.hpm)
	$label2.text = "XP: " + str(PlayerManager.PLAYER_STATS.xp) + "/" + str(PlayerManager.get_next_level_xp())
#	$label3.text = Lang.get_text("ui_player_extra_dice")+": " + str(PlayerManager.PLAYER_STATS.dice_parts) + "/" + str(PlayerManager.get_next_level_xp())
