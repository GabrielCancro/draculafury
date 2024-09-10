extends Node2D

var enemy_data

func _ready():
	$Button.connect("button_down",self,"move",[-1])

func set_data(_data):
	enemy_data = _data
	position = Vector2(1300,600)
	set_tile_pos(8,0)
	$Sprite.texture = load("res://assets/"+enemy_data.img+".png")
	Effector.appear(self)

func set_tile_pos(_x,_y):
	enemy_data["tile_pos_x"] = _x 
	enemy_data["tile_pos_y"] = _y
	print("MOVE ENEMY: "+enemy_data.name,"  to: ",_x)
	var nx = 1200 - 800 + ( _x * 100 )
	var ny = 620
	Effector.move_to(self,Vector2(nx,ny))

func move(val):
	set_tile_pos(enemy_data["tile_pos_x"]+val,enemy_data["tile_pos_y"])
