extends Control

var enemy
var hint_data={"owner":self,"panel":null,"code":null,"over_node":"HintNode","callback":"hint_cb"}

# Called when the node enters the scene tree for the first time.
func _ready():
	Effector.add_hint(hint_data)
	$label.visible = false

func set_data(_enemy):
	enemy = _enemy
	if enemy:
		hint_data.code = "en_"+enemy+"_name"
		$Sprite.modulate = Color(1,1,1,1)
		$Sprite2.frame = EnemyManager.get_enemy_data(enemy).ret
		$Sprite2.visible = true
	else:
		$Sprite.modulate = Color(.8,.8,.8,1)
		$Sprite2.visible = false

func hint_cb():
	$label.visible = hint_data.is_visible
	if enemy: $label.text = Lang.get_text("en_"+enemy+"_name").to_upper()
	else: $label.text = ""

