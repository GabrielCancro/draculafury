extends Node2D

var fly_ttl = 0

func _ready():
	$Tween.interpolate_property(self,"global_position",null,Vector2(1600,150),1.2,Tween.TRANS_QUAD,Tween.EASE_IN)
	$Tween.interpolate_property(self,"modulate:a",null,0,.2,Tween.TRANS_QUAD,Tween.EASE_OUT,1)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	queue_free()

func _process(delta):
	fly_ttl += delta*20
	$Sprite.position.y = sin(fly_ttl)*10
