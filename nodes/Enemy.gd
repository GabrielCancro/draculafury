extends Node2D

var enemy_data
var floor_y = 670
var fly_y = -220
var fly_ttl = 0
var step_size
var hint_data={"owner":self,"panel":"enemy","code":null,"over_node":null,"callback":null,"over_area":"Button"}

signal end_move()

func _ready():
	modulate.a = 0
	Effector.appear(self)
	Effector.add_hint(hint_data)

func _process(delta):
	if enemy_data.fly: 
		fly_ttl += delta*7
		$Sprite.position.y = sin(fly_ttl)*10

func set_data(_data,_xpos):
	step_size = (1600 - EnemyManager.end_x_pos)/EnemyManager.max_x_pos
	enemy_data = _data
	$Label.text = str(enemy_data.hp)
	position = Vector2(1300,600)
	set_tile_pos(_xpos)
	$Sprite.texture = load("res://assets/enemies/en_"+enemy_data.name+".png")
	set_stoned_skin(true)

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
	if "ability" in enemy_data && enemy_data.ability=="extra_mov" && randi()%100<30: val -= 1
	set_stoned_skin(true)
	for i in abs(val):
		if enemy_data.tile_pos_x==0 and sign(val)<0: break
		var swap_en = EnemyManager.get_enemy_in_pos(enemy_data.tile_pos_x+sign(val),enemy_data.tile_pos_y)
		if swap_en: EnemyManager.swap_enemies(self,swap_en)
		else: set_tile_pos(enemy_data.tile_pos_x+sign(val))
		yield(get_tree().create_timer(.35),"timeout")
	if try_attack(): yield(get_tree().create_timer(.7),"timeout")
	yield(get_tree().create_timer(.2),"timeout")
	emit_signal("end_move")

func try_attack():
	if enemy_data.tile_pos_x < enemy_data.ran:
		Effector.move_to_yoyo(self,Vector2(-60,0))
		yield(get_tree().create_timer(.2),"timeout")
		PlayerManager.damage(enemy_data.dam)
		return true
	else: return false

func enemy_damage(dam):
	if set_stoned_skin(false): return
	enemy_data.hp -= dam
	if enemy_data.hp<0: enemy_data.hp = 0
	$Label.text = str(enemy_data.hp)
	Effector.damage_fx(self,dam)
	if enemy_data.hp<=0:
		Effector.disappear(self)
		yield(get_tree().create_timer(.5),"timeout")
		EnemyManager.ENEMIES_ACTIVES.erase(self)
		PlayerManager.add_xp()
		ItemManager.throw_with_probability(position.x+20)
		queue_free()

func set_stoned_skin(val):
	if !"ability" in enemy_data or enemy_data.ability!="stone_skin": return false
	if !"stoned_skin" in enemy_data: enemy_data["stoned_skin"] = false
	var have_change = (enemy_data["stoned_skin"] != val)
	enemy_data["stoned_skin"] = val
	if val: 
		$Sprite.material = preload("res://assets/sh_outline.tres")
		$Sprite.material.set_shader_param("line_color",Color(.8,.8,.8,1))
		$Sprite.material.set_shader_param("line_scale",8)
	else: 
		$Sprite.material = null
		if have_change: Effector.shake(self)
	return have_change
