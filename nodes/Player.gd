extends Sprite

var anim = "idle"
var step = 0
var default_speed = .25

signal end_anim

var ANIMS = {
	"idle":{"start":0,"end":1,"speed":.5},
	"rapier":{"start":2,"end":6},
	"gun":{"start":7,"end":9},
	"crossbow":{"start":10,"end":12},
	"dynamite":{"start":13,"end":15},
	"shotgun":{"start":16,"end":18},
	"stake":{"start":19,"end":22},
	"kick":{"start":23,"end":25},
	"breathe":{"start":26,"end":29},
}
# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.connect("timeout",self,"animator_cb")
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
