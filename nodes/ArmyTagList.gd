extends Control

# ability damage largerange shortrange multitarget 
# ammunition enlist exhaustible restricted

func set_tags(army_code,powered=false):
	for c in $HBox.get_children(): c.visible = false
	var army_data = ArmyManager.get_army_data(army_code)
	var tags = army_data.tags
	if "damage" in tags:
		$HBox/damage/Label.remove_color_override("font_outline_modulate")
		$HBox/damage/Label.add_color_override("font_outline_modulate",Color(.51,.12,.06,1))
		$HBox/damage/Label.text = str(army_data.damage)
		$HBox/damage.visible = true
	if powered && "damage_pow" in army_data:
		$HBox/damage/Label.text = str(army_data.damage_pow)
		$HBox/damage/Label.remove_color_override("font_outline_modulate")
		$HBox/damage/Label.add_color_override("font_outline_modulate",Color(.4,.5,0,1))
		$HBox/damage.visible = true
	if "ammunition" in tags:
		$HBox/ammunition/Label.text = str(army_data.amount)
		$HBox/ammunition.visible = true
		$HBox/reload.visible = true
	if "shortrange" in tags:
		$HBox/shortrange.visible = true
	if "largerange" in tags:
		$HBox/largerange.visible = true
	if "multitarget" in tags:
		$HBox/multitarget.visible = true
	if "exhaustible" in tags:
		$HBox/exhaustible.visible = true
