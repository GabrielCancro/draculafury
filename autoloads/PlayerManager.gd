extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func damage(dam):
	var player_node = get_node("/root/Game/Player")
	Effector.shake(player_node)
