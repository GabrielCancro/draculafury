extends Node2D

var vx = 550
var vy = -1000
var ttl = 1

func _ready():
	position = get_node("/root/Game/Player").position + Vector2(200,-250)

func _process(delta):
	position += Vector2(vx,vy) * delta
	vy += 2500 * delta 
	rotation -= 3*delta
	ttl -= delta
	if ttl<=0: queue_free()
