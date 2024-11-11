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
	audio.play()
	yield(audio,"finished")
	audio.queue_free()
