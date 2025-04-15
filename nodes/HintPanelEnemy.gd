extends ColorRect

func _ready():
	visible = false

func show_hint(hint_data):
	var enemy_data = hint_data.owner.enemy_data
	$lb_name.text = Lang.get_text("en_"+enemy_data.name+"_name")
	$stats/lb_dm.text = str(enemy_data.dam)
	$stats/lb_mv.text = str(enemy_data.mov)
	$stats/lb_hp.text = str(enemy_data.hp)
	$lb_desc.text = '"'+Lang.get_text("en_"+enemy_data.name+"_desc")+'"'
	if "ability" in enemy_data: $lb_ability.text = Lang.get_text("en_ab_"+enemy_data.ability+"_desc")
	else: $lb_ability.text = ""
	if enemy_data.name == "dracula": $lb_ability.text = Lang.get_text("en_dracula_skill_"+EnemyManager.get_dracula_skill())
	#$Sprite2.texture = load("res://assets/enemies/en_ret_"+enemy_data.name+".png")
#	rect_global_position.y = 240
#	rect_global_position.x = hint_data.owner.global_position.x - 470
#	if enemy_data.fly: rect_global_position.x -= 80
#	if rect_global_position.x < 20: rect_global_position.x  = 20
	visible = true

func hide_hint():
	visible = false
