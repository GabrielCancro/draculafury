extends Node

var scene
var song:AudioStreamPlayer


func _ready():
	song = AudioStreamPlayer.new()
	add_child(song)
	song.stream = preload("res://assets/sfx/song1.ogg")
	song.volume_db = -15

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

func play_music():
	song.play()
	
func stop_music():
	song.stop()

func play_hit():
	randomize()
	var i = randi()%4+1
	play_sound("hit"+str(i))
