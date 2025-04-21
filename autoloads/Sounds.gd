extends Node

var scene
var song:AudioStreamPlayer
var MUSICS = {
	"game":load("res://assets/sfx/song1.ogg"),
	"menu":load("res://assets/sfx/ambient.mp3")
}


func initialize_sounds():
	song = AudioStreamPlayer.new()
	add_child(song)
	song.volume_db = -15

func set_audio_scene(_scene):
	scene = _scene

func play_sound(id):
	var audio = AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = load("res://assets/sfx/"+id+".ogg")
	if !audio.stream: Effector.show_float_text("NO SOUND "+id)
	audio.stream.loop = false
	audio.play()
	audio.connect("finished",audio,"queue_free")
	return audio

func play_music(code):
	song.stream = MUSICS[code]
	song.play()
	
func stop_music():
	song.stop()

func play_hit():
	randomize()
	var i = randi()%4+1
	play_sound("hit"+str(i))

func set_vol(val):
	var db = (val-100)*0.33
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, db )
	AudioServer.set_bus_mute(bus_index, (val==0) )
