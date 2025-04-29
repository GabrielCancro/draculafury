extends ColorRect

var fixed = false
var hint_data

func _ready():
	init_buttons()
	hide_hint()

func _process(delta):
	if fixed && !$actions.get_rect().has_point(get_local_mouse_position()):
		fixed = false
		hide_hint()

func show_hint(_hint_data):
	set_fixed()
	hint_data = _hint_data
	if !hint_data.owner.item_data: return
	var item_data = hint_data.owner.item_data
	$lb_name.text = Lang.get_text("it_"+item_data.code+"_name").to_upper()
	$lb_desc.text = Lang.get_text("it_"+item_data.code+"_desc")
	$Sprite2.frame = item_data.ico
	rect_global_position.x = hint_data.owner.rect_global_position.x-200
	if rect_global_position.x < 35: rect_global_position.x = 35
#	if hint_data.owner.rect_position.x<100:
#		rect_global_position.x = 200
#		rect_global_position.y = hint_data.owner.rect_global_position.y
#	else:
#		rect_global_position = Vector2(520,300)
	visible = true

func hide_hint():
	if !fixed:
		visible = false
		$actions.visible = false

func set_fixed():
	fixed = true
	$actions.visible = true

func on_click_button(btn):
	fixed = false
	hide_hint()
	if btn=="USE":
		hint_data.owner.on_use_item()
	elif btn=="DISCARD":
		hint_data.owner.on_discard()

func init_buttons():
	$actions/ButtonUse/Label.text = "USAR"
	$actions/ButtonUse/HintNode/Label2.text = $actions/ButtonUse/Label.text
	var hint_data1={"owner":$actions/ButtonUse,"panel":null,"code":null,"over_node":"HintNode","callback":null}
	Effector.add_hint(hint_data1)
	$actions/ButtonUse.connect("button_down",self,"on_click_button",["USE"])
	
	$actions/ButtonDiscard/Label.text = "TIRAR"
	$actions/ButtonDiscard/HintNode/Label2.text = $actions/ButtonDiscard/Label.text
	var hint_data2={"owner":$actions/ButtonDiscard,"panel":null,"code":null,"over_node":"HintNode","callback":null}
	Effector.add_hint(hint_data2)
	$actions/ButtonDiscard.connect("button_down",self,"on_click_button",["DISCARD"])
