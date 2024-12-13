extends Control

# ability damage largerange shortrange multitarget 
# ammunition enlist exhaustible restricted

func _set_tags(army_code):
	for c in $HBox.get_children(): c.visible = false
