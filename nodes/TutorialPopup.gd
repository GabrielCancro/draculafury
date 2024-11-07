extends ColorRect

signal close_popup()

func _ready():
	visible = false
	modulate.a = 0
	for p in $Pages.get_children():
		p.get_node("btn").connect("button_down",self,"on_click_btn",[p.name])
		p.get_node("Label").text = Lang.get_text("tuto_"+p.name)

func show_popup(page):
	for p in $Pages.get_children(): p.visible = false
	get_node("Pages/"+page).visible = true
	Effector.appear(self)
	visible = true

func hide_popup():
	Effector.disappear(self)
	yield(get_tree().create_timer(1),"timeout")
	visible = false
	emit_signal("close_popup")

func on_click_btn(page):
	hide_popup()
