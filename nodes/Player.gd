extends Sprite

var anim = "idle"
var step = 0
var default_speed = 0.25

signal end_anim

var ANIMS = {
	"idle":{"start":0,"end":1,"speed":0.5},
	"rapier":{"start":8,"end":10},
	"gun":{"start":12,"end":14},
	"crossbow":{"start":16,"end":18},
	"dynamite":{"start":20,"end":22},
	"shotgun":{"start":24,"end":26},
	"stake":{"start":32,"end":34},
	"kick":{"start":28,"end":30},
	"breathe":{"start":2,"end":7},
}
# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.connect("timeout",self,"animator_cb")
	$Timer.wait_time = default_speed
	animator_cb()
	$Timer.start()

func animator_cb():
	frame = ANIMS[anim].start + step
	step += 1
	if step > ANIMS[anim].end - ANIMS[anim].start: 
		emit_signal("end_anim")
		set_anim("idle")

func set_anim(_anim="idle"):
	anim = _anim
	step = 0
	if "speed" in ANIMS[anim]: $Timer.wait_time = ANIMS[anim].speed
	else: $Timer.wait_time = default_speed

func set_random_anim():
	randomize()
	var index = 1 + (randi() % (ANIMS.keys().size()-1))
	var key = ANIMS.keys()[index]
	set_anim(key)
