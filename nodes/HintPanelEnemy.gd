extends ColorRect

func _ready(): 
	SizerManager.connect("on_size_change",self,"on_size_change")
	visible = false

func show_hint(hint_data):
	var enemy_data = hint_data.owner.enemy_data
	$lb_name.text = Lang.get_text("en_"+enemy_data.name+"_name")
	$lb_stats.text = "ATK:"+str(enemy_data.dam)+"   "
	$lb_stats.text += "MOV:"+str(enemy_data.mov)+"   "
	$lb_stats.text += "HP:"+str(enemy_data.hp)+"   "
	$lb_desc.text = Lang.get_text("en_"+enemy_data.name+"_desc")
	if "ability" in enemy_data: $lb_ability.text = Lang.get_text("en_ab_"+enemy_data.ability+"_desc")
	else: $lb_ability.text = ""
	$Sprite2.frame = EnemyManager.get_enemy_data(enemy_data.name).ret
	rect_global_position.y = 240
	rect_global_position.x = hint_data.owner.global_position.x - 470
	if enemy_data.fly: rect_global_position.x -= 80
	visible = true

func hide_hint():
	visible = false

func on_size_change(scale):
	rect_scale = Vector2(scale,scale)
