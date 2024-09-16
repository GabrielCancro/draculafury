extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerManager.connect("on_change_stats",self,"update_stats")

func update_stats(ps):
	$HPBar.max_value = ps.hpm*100
	$Tween.remove_all()
	$Tween.interpolate_property($HPBar,"value",null,ps.hp*100,.3,Tween.TRANS_QUAD,Tween.EASE_IN)
	$Tween.start()
	for xp in $XPHBox.get_children():
		if(xp.get_index()<ps.xp): xp.modulate = Color(1,1,1,1)
		else: xp.modulate = Color(.3,.3,.3,1)
