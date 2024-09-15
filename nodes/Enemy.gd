extends Node2D

var enemy_data
var floor_y = 800
var end_x = 1500
var step_size = 120

signal end_move()

func _ready():
	$Button.connect("button_down",self,"move")

func set_data(_data):
	enemy_data = _data
	$Label.text = str(enemy_data.hp)
	position = Vector2(1300,600)
	set_tile_pos(8)
	$Sprite.texture = load("res://assets/enemies/en_"+enemy_data.name+".png")
	Effector.appear(self)

func set_tile_pos(_x):
	enemy_data["tile_pos_x"] = _x 
	enemy_data["tile_pos_y"] = 0
	if enemy_data.fly: enemy_data["tile_pos_y"] = 1
	z_index = 100 - enemy_data.tile_pos_x*10 + enemy_data.tile_pos_y
	#print("MOVE ENEMY: "+enemy_data.name,"  to: ",_x)
	var nx = end_x - step_size*8 + ( enemy_data.tile_pos_x * 100 )
	var ny = floor_y - ( enemy_data.tile_pos_y * 180 )
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
	Effector.show_damage_text(dam,self.position+Vector2(0,-150))
	Effector.shake(self)
	if enemy_data.hp<=0:
		EnemyManager.ENEMIES_ACTIVES.erase(self)
		Effector.disappear(self)
		yield(get_tree().create_timer(.5),"timeout")
		queue_free()
