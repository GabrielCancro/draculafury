extends Node2D

var enemy_data

func _ready():
	$Button.connect("button_down",self,"move")

func set_data(_data):
	enemy_data = _data
	position = Vector2(1300,600)
	set_tile_pos(8)
	$Sprite.texture = load("res://assets/en_"+enemy_data.name+".png")
	Effector.appear(self)

func set_tile_pos(_x):
	enemy_data["tile_pos_x"] = _x 
	enemy_data["tile_pos_y"] = 0
	if enemy_data.fly: enemy_data["tile_pos_y"] = 1
	print("MOVE ENEMY: "+enemy_data.name,"  to: ",_x)
	var nx = 1200 - 800 + ( enemy_data.tile_pos_x * 100 )
	var ny = 620 - ( enemy_data.tile_pos_y * 180 )
	Effector.move_to(self,Vector2(nx,ny))

func try_attack():
	if enemy_data.tile_pos_x < enemy_data.ran:
		PlayerManager.damage(enemy_data.dam)
		return true
	else: return false

func move(val = -enemy_data.mov):
	if try_attack(): return
	for i in abs(val):
		set_tile_pos(enemy_data.tile_pos_x+sign(val))
		yield(get_tree().create_timer(.35),"timeout")
		if enemy_data.tile_pos_x == 0: break
