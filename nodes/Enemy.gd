extends Node2D

var enemy_data
var floor_y = 760
var fly_y = -300
var fly_ttl = 0
var step_size
var hint_data={"owner":self,"panel":"enemy","code":null,"over_node":null,"callback":null,"over_area":"Button"}
var stuned = 0
var middle_point_y = 0
var ttl_hpbar = 0

signal end_move()
signal end_anim()

func _ready():
	modulate.a = 0
	Effector.appear(self)
	Effector.add_hint(hint_data)
	$Button.connect("mouse_entered",self,"show_hp")
	$HPBar/DamageImg.visible = false
	reset_sprite_texture()

func reset_sprite_texture():
	$Sprite.texture = load("res://assets/enemies/en_"+enemy_data.name+".png")
	$Sprite.position.y = 20 - $Sprite.texture.get_size().y/2 * $Sprite.scale.y
	middle_point_y = 20 - $Sprite.texture.get_size().y/2 * $Sprite.scale.y
	$m2.rect_position.y = - $Sprite.texture.get_size().y * $Sprite.scale.y
	$HPBar.rect_position.y = $m2.rect_position.y
	$Stun.position.y = 40 - $Sprite.texture.get_size().y * $Sprite.scale.y
	$Stun.position.x = -30

func show_hp(time=2):
	ttl_hpbar = 2

func _process(delta):
	if enemy_data.fly: 
		fly_ttl += delta*7
		$Sprite.position.y = middle_point_y + sin(fly_ttl)*10
		
	$HPBar.visible = (ttl_hpbar>0)
	if $HPBar.visible:
		$HPBar.modulate.a = clamp(ttl_hpbar*10,0,1)
		if $HPBar/HPBar.value > enemy_data["hp"] * 100: $HPBar/HPBar.value -= 3
		elif $HPBar/HPBar.value < enemy_data["hp"] * 100: $HPBar/HPBar.value += 3
		ttl_hpbar -= delta
	else:
		$HPBar/DamageImg.visible = false

func set_data(_data,_xpos):
	step_size = (1920 - EnemyManager.end_x_pos)/EnemyManager.max_x_pos
	enemy_data = _data
	$HPBar/HPBar.value = 0
	$HPBar/HPBar.max_value = enemy_data["hpm"] * 100
	$HPBar/lb_name.text = Lang.get_text("en_"+enemy_data.name+"_name").to_upper()
	show_hp()
	$Label.text = str(enemy_data.hp)
	position = Vector2(1500,floor_y)
	set_tile_pos(_xpos)
	if enemy_data.name=="dracula": EnemyManager.apply_dracula_skill(self)
	if EnemyManager.get_dracula_skill()=="redmoon": enemy_data.dam += 1
	set_stoned_skin(true)
	ArmyManager.check_enemy_in_trap(self)

func set_tile_pos(_x):
	enemy_data["tile_pos_x"] = _x 
	enemy_data["tile_pos_y"] = 0
	if enemy_data.fly: enemy_data["tile_pos_y"] = 1
	z_index = 100 - enemy_data.tile_pos_x*10 - enemy_data.tile_pos_y
	#print("MOVE ENEMY: "+enemy_data.name,"  to: ",_x)
	var nx = EnemyManager.end_x_pos + (step_size*enemy_data.tile_pos_x)
	var ny = floor_y + ( enemy_data.tile_pos_y * fly_y )
	Effector.move_to(self,Vector2(nx,ny))

func move(val = -enemy_data.mov):
	yield(get_tree().create_timer(.35),"timeout")
	show_hp()
	if has_ability_by_percent("extra_mov",30): val -= 1
	set_stoned_skin(true)
	if has_ability_by_percent("wolf_herd",50):
		Sounds.play_sound("wolf_howl")
		yield(get_tree().create_timer(.2),"timeout")
		Effector.scale_boom(self)
		yield(get_tree().create_timer(.8),"timeout")
		EnemyManager.add_enemy("wolf")
		yield(get_tree().create_timer(.5),"timeout")
		emit_signal("end_move")
		return
	if is_stunned():
		Effector.scale_boom(self)
		yield(get_tree().create_timer(.7),"timeout")
		dec_stun()
		yield(get_tree().create_timer(.7),"timeout")
		emit_signal("end_move")
		return
	for i in abs(val):
		if enemy_data.tile_pos_x==0 and sign(val)<0: break
		var swap_en = EnemyManager.get_enemy_in_pos(enemy_data.tile_pos_x+sign(val),enemy_data.tile_pos_y)
		if swap_en: EnemyManager.swap_enemies(self,swap_en)
		else: set_tile_pos(enemy_data.tile_pos_x+sign(val))
		Sounds.play_sound("move_enemy")
		yield(get_tree().create_timer(.35),"timeout")
		if ArmyManager.check_enemy_in_trap(self): yield(get_tree().create_timer(.7),"timeout")
	if can_attack(): 
		yield(get_tree().create_timer(.3),"timeout")
		attack_player()
		yield(get_tree().create_timer(.6),"timeout")
	yield(get_tree().create_timer(.2),"timeout")
	emit_signal("end_move")

func can_attack():
	return (enemy_data.tile_pos_x < enemy_data.ran)

func attack_player():
	Effector.move_to_yoyo($Sprite,Vector2(-60,0))
	yield(get_tree().create_timer(.2),"timeout")
	PlayerManager.damage(enemy_data.dam)

func enemy_damage(dam):
	if set_stoned_skin(false): return
	enemy_data.hp -= dam
	if enemy_data.hp<0: enemy_data.hp = 0
	$HPBar/DamageImg/lb_damage.text = "-"+str(dam)
	$HPBar/DamageImg.visible = true
	Effector.scale_boom($HPBar/DamageImg)
	show_hp()
	#$Label.text = str(enemy_data.hp)
	Effector.damage_fx(self,dam)
	if enemy_data.hp<=0:
		resurrection_dracula()
		Effector.disappear(self)
		yield(get_tree().create_timer(.5),"timeout")
		EnemyManager.ENEMIES_ACTIVES.erase(self)
		ItemManager.throw_with_probability(position.x+20)
		PlayerManager.PLAYER_STATS.kills += 1
		yield(get_tree().create_timer(.5),"timeout")
		PlayerManager.add_xp(1)
		queue_free()

func add_stun(val=1):
	stuned = 1
	$Stun.emitting = is_stunned()

func dec_stun(val=1):
	stuned = 0
	$Stun.emitting = is_stunned()

func is_stunned():
	return (stuned>0)

func enemy_set_hp(val):
	enemy_data.hpm = val
	enemy_data.hp = val
	$Label.text = str(enemy_data.hp)

func set_stoned_skin(val):
	if !"ability" in enemy_data or enemy_data.ability!="stone_skin": return false
	if !"stoned_skin" in enemy_data: enemy_data["stoned_skin"] = false
	var have_change = (enemy_data["stoned_skin"] != val)
	enemy_data["stoned_skin"] = val
	if val: 
		$Sprite.material = load("res://assets/shaders/sh_outline.tres")
		$Sprite.material.set_shader_param("line_color",Color(.8,.8,.8,1))
		$Sprite.material.set_shader_param("line_scale",12)
	else: 
		$Sprite.material = null
		if have_change: Effector.shake(self)
	return have_change

func has_ability_by_percent(ab_code,percent=100):
	return ("ability" in enemy_data && enemy_data.ability==ab_code && randi()%100<=percent)

func resurrection_dracula():
	if enemy_data.name != "dracula": return
	var nd = load("res://nodes/fx/DraculaFly.tscn").instance()
	nd.global_position = global_position
	get_node("/root/Game").add_child(nd)
	yield(get_tree().create_timer(.7),"timeout")
	EnemyManager.dracula_resurrections += 1
	get_node("/root/Game/CLUI/WaveUI").add_dracula_to_wave()
