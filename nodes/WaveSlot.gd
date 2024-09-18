extends Control

var enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_data(_enemy):
	enemy = _enemy
	if enemy:
		$Sprite.modulate = Color(1,1,1,1)
		$Sprite2.frame = EnemyManager.get_frame(enemy)
		$Sprite2.visible = true
	else:
		$Sprite.modulate = Color(.8,.8,.8,1)
		$Sprite2.visible = false
