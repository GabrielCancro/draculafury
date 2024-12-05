extends Control


func _ready():
	$skip.connect("button_down",self,"on_skip")
	Sounds.stop_music()
	SaveManager.load_store_data()
	OS.window_fullscreen = SaveManager.savedData.fullscreen
	Sounds.set_vol(SaveManager.savedData.master_vol)
	$TextureRect.modulate.a = 0
	
	yield(get_tree().create_timer(1),"timeout")
	if SaveManager.demo:
		$VideoPlayer.queue_free()
		
		Effector.appear($TextureRect)
		yield(get_tree().create_timer(2),"timeout")
		Effector.disappear($TextureRect)
	else:
		$VideoPlayer.play()
		yield($VideoPlayer,"finished")
	yield(get_tree().create_timer(.7),"timeout")
	on_skip()

func on_skip():
	get_tree().change_scene("res://scenes/Menu.tscn")
