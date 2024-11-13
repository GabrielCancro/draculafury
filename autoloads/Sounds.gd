extends Node

var scene

func _ready():
	pass

func set_audio_scene(_scene):
	scene = _scene

func play_sound(id):
	var audio = AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = load("res://assets/sfx/"+id+".ogg")
	if !audio.stream: Effector.show_float_text("NO SOUND "+id)
	audio.play()
	yield(audio,"finished")
	audio.queue_free()
