extends ColorRect

func _ready():
	visible = false

func show_hint(hint_data):
	var enemy_data = hint_data.owner.enemy_data
	$lb_name.text = Lang.get_text("en_"+enemy_data.name+"_name").to_upper()
	$stats/lb_dm.text = str(enemy_data.dam)
	$stats/lb_mv.text = str(enemy_data.mov)
	$stats/lb_hp.text = str(enemy_data.hp)
	$lb_desc.text = '"'+Lang.get_text("en_"+enemy_data.name+"_desc")+'"'
	$ability1.visible = ("ability" in enemy_data)
	if "ability" in enemy_data: 
		$ability1/ico.frame = get_ab_ico(enemy_data.ability)
		$ability1/lb_ab_name.add_color_override("font_color",get_ab_color(enemy_data.ability))
		$ability1/lb_ab_name.text = "   "+Lang.get_text("en_ab_"+enemy_data.ability+"_name").to_upper()
		var ch_count = floor(6+Lang.get_text("en_ab_"+enemy_data.ability+"_name").length()*1.4)
		$ability1/lb_ab_desc.text = ""
		for i in range(ch_count): $ability1/lb_ab_desc.text += " "
		$ability1/lb_ab_desc.text += Lang.get_text("en_ab_"+enemy_data.ability+"_desc")
	if enemy_data.name == "dracula": $lb_ability.text = Lang.get_text("en_dracula_skill_"+EnemyManager.get_dracula_skill())
	#$Sprite2.texture = load("res://assets/enemies/en_ret_"+enemy_data.name+".png")
#	rect_global_position.y = 240
	rect_global_position.x = hint_data.owner.global_position.x - 800
	if rect_global_position.x < 250: rect_global_position.x  += 950
#	if enemy_data.fly: rect_global_position.x -= 80
	visible = true

func hide_hint():
	visible = false

func get_ab_ico(ab_name):
	if ab_name == "extra_mov": return 1
	return 8

func get_ab_color(ab_name):
	if ab_name == "extra_mov": return Color("#358dbd")
	return Color("#c0c0c0")
