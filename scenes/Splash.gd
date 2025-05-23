extends Control

var preloads = [
	load("res://assets/sfx/ambient.mp3"),
	load("res://assets/sfx/intro_splash.ogg"),
	load("res://assets/sfx/song1.ogg"),
]
var sfx

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_autoloads()
	#get_tree().set_screen_stretch(1,1,Vector2(1920,1080))
	Sounds.initialize_sounds()
	$Button.connect("button_down",self,"next_scene")
	Sounds.stop_music()
	SaveManager.load_store_data()
	OS.window_fullscreen = SaveManager.savedData.fullscreen
	Sounds.set_vol(SaveManager.savedData.master_vol)
	play_anim()
	#get_tree().change_scene("res://scenes/Menu.tscn")

func play_anim():
	var cpos = get_viewport_rect().size/2
	$Pump.position = cpos
	$Pump.position.y -= 40
	$Logo.rect_position.y -= 40
	$Pump.modulate.a = 0
	$Logo.modulate.a = 0
	$Pump.play("idle")
	
	$Tween.interpolate_property($Pump,"modulate:a",0,1,0.2,Tween.TRANS_QUAD,Tween.EASE_IN,1)
	$Tween.start()
	yield(get_tree().create_timer(1),"timeout")
	sfx = Sounds.play_sound("intro_splash")
	yield(get_tree().create_timer(1),"timeout")
	
	$Pump.play("eye")
	$Tween.interpolate_property($Logo,"modulate:a",0,1,0.5,Tween.TRANS_QUAD,Tween.EASE_OUT,.2)
	$Tween.interpolate_property($Pump,"position:x",null,cpos.x-280,0.2,Tween.TRANS_QUAD,Tween.EASE_OUT,.2)
	$Tween.interpolate_property($Logo,"rect_position:x",null,cpos.x-130,0.2,Tween.TRANS_LINEAR,Tween.EASE_IN,.2)
	$Tween.start()
	yield(get_tree().create_timer(1),"timeout")
	$Pump.play("idle")
	yield(get_tree().create_timer(1),"timeout")
	$Tween.interpolate_property($Pump,"modulate:a",1,0,0.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.interpolate_property($Logo,"modulate:a",1,0,0.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.interpolate_property($TextureRect,"modulate:a",1,0,0.3,Tween.TRANS_QUAD,Tween.EASE_OUT,.2)
	$Tween.start()
	yield(get_tree().create_timer(1),"timeout")
	next_scene()

func next_scene():
	if is_instance_valid(sfx): sfx.stop()
	get_tree().change_scene("res://scenes/Menu.tscn")

func set_autoloads():
	var autoloads = [
		"ArmyManager",
		"Effector",
		"EnemyManager",
		"ItemManager",
		"Lang",
		"PlayerManager",
		"PopupManager",
		"SaveManager",
		"Sounds",
		"UpgradesManager",
	]
	for au in autoloads:
		print("/root/"+au+"  ->  "+"res://autoloads/"+au+".gd")
		get_tree().root.get_node("/root/"+au).set_script(load("res://autoloads/"+au+".gd"))
