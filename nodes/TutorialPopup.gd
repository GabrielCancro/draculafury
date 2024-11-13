extends ColorRect

signal close_popup()
signal skip_tutorial()
var showed = []

func _ready():
	visible = false
	modulate.a = 0
	$btn_skip.connect("button_down",self,"on_click_skip")
	for p in $Pages.get_children():
		p.get_node("btn").connect("button_down",self,"on_click_btn",[p.name])
		p.get_node("Label").text = Lang.get_text("tuto_"+p.name)

func show_popup(page):
	if page in showed: 
		emit_signal("close_popup")
		return
	showed.append(page)
	$btn_skip.modulate.a = 0
	for p in $Pages.get_children(): p.visible = false
	get_node("Pages/"+page).visible = true
	Effector.appear(self)
	visible = true
	yield(get_tree().create_timer(.5),"timeout")
	Effector.appear($btn_skip)

func hide_popup():
	Effector.disappear(self)
	yield(get_tree().create_timer(1),"timeout")
	visible = false
	emit_signal("close_popup")

func on_click_btn(page):
	Sounds.play_sound("button1")
	hide_popup()

func on_click_skip():
	Sounds.play_sound("button1")
	emit_signal("skip_tutorial")
	hide_popup()
