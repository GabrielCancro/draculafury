extends Node2D

var enemy_data
var floor_y = 680
var fly_y = -220
var end_x = 1500
var step_size = 150

signal end_move()

func _ready():
	modulate.a = 0
	Effector.appear(self)
	$Button.connect("button_down",self,"move")

func set_data(_data):
	enemy_data = _data
	$Label.text = str(enemy_data.hp)
	position = Vector2(1300,600)
	set_tile_pos(EnemyManager.max_x_pos)
	$Sprite.texture = load("res://assets/enemies/en_"+enemy_data.name+".png")

func set_tile_pos(_x):
	enemy_data["tile_pos_x"] = _x 
	enemy_data["tile_pos_y"] = 0
	if enemy_data.fly: enemy_data["tile_pos_y"] = 1
	z_index = 100 - enemy_data.tile_pos_x*10 - enemy_data.tile_pos_y
	#print("MOVE ENEMY: "+enemy_data.name,"  to: ",_x)
	var nx = 1600 - (EnemyManager.max_x_pos-enemy_data.tile_pos_x) * step_size - step_size/2
	var ny = floor_y + ( enemy_data.tile_pos_y * fly_y )
	Effector.move_to(self,Vector2(nx,ny))

func move(val = -enemy_data.mov):
	yield(get_tree().create_timer(.35),"timeout")
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
		PlayerManager.damage(enemy_data.dam)
		return true
	else: return false

func enemy_damage(dam):
	enemy_data.hp -= dam
	if enemy_data.hp<0: enemy_data.hp = 0
	$Label.text = str(enemy_data.hp)
	Effector.damage_fx(self,dam)
	if enemy_data.hp<=0:
		Effector.disappear(self)
		yield(get_tree().create_timer(.5),"timeout")
		EnemyManager.ENEMIES_ACTIVES.erase(self)
		PlayerManager.add_xp()
		queue_free()
