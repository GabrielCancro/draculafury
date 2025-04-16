extends Control

# ability damage largerange shortrange multitarget 
# ammunition enlist exhaustible restricted

func set_tags(army_code):
	for c in $HBox.get_children(): c.visible = false
	var army_data = ArmyManager.get_army_data(army_code)
	var tags = army_data.tags
	if "damage" in tags:
		$HBox/damage/Label.text = str(army_data.damage)
		$HBox/damage.visible = true
	if "ammunition" in tags:
		$HBox/ammunition/Label.text = str(army_data.amount)
		$HBox/ammunition.visible = true
	if "damage" in tags:
		$HBox/reload.visible = true
	if "shortrange" in tags:
		$HBox/shortrange.visible = true
	if "largerange" in tags:
		$HBox/largerange.visible = true
	if "multitarget" in tags:
		$HBox/multitarget.visible = true
	if "exhaustible" in tags:
		$HBox/exhaustible.visible = true
