extends Control

enum GameState {START,ACTIONS,ATTACKS,ENEMIES,WAVE}
var current_state
var disable_dices_click = true

func _ready():
	set_floor_marks()
	EnemyManager.initialize_data()
	PlayerManager.initialize_data()
	$CLUI/ButtonStates.disabled = true
	$CLUI/ButtonStates.modulate.a = 0
	$CLUI/ButtonStates.connect("button_down",self,"on_button_states")	
	$CLUI/DiceSet.connect("on_click_dice",self,"on_click_dice")
	$CLUI/PlayerUI.update_stats(PlayerManager.PLAYER_STATS)
	$CLUI/UpgradePopup.connect("on_hide_popup",$CLUI/Belt,"update_belt")
	
	$CLUI/ButtonHacks.connect("button_down",self,"on_button_hacks")
	$CLUI/Hacks/ButtonAddEnemy.connect("button_down",get_node("/root/Game/CLUI/WaveUI"),"advance_wave")
	$CLUI/Hacks/ButtonAddDice.connect("button_down",$CLUI/DiceSet,"add_extra_dice")
	$CLUI/Hacks/ButtonAnim.connect("button_down",$Player,"set_random_anim")
	$CLUI/Hacks/ButtonFxDyn.connect("button_down",ArmyManager,"run_army_action",["dynamite"])
	$CLUI/Hacks/ButtonUpgrade.connect("button_down",$CLUI/UpgradePopup,"show_popup")
	$CLUI/Hacks/ButtonXP.connect("button_down",PlayerManager,"add_xp")
	$CLUI/Hacks/ButtonMovEnemies.connect("button_down",EnemyManager,"force_move_enemy")
	$CLUI/Hacks/ButtonAddItem.connect("button_down",ItemManager,"throw_random_item")
	
	yield($CLUI/TutorialPopup,"close_popup")
	yield(get_tree().create_timer(.5),"timeout")
	$CLUI/WaveUI.next_wave()
	yield(get_tree().create_timer(2),"timeout")
	$CLUI/WaveUI.advance_wave()
	yield(get_tree().create_timer(2),"timeout")
	change_state(GameState.START)

func change_state(new_state):
	current_state = new_state
	print("NEW STATE ",GameState.keys()[current_state])
	hide_states_button()
	if current_state == GameState.START:
		Effector.show_float_text("PLAYER TURN!")
		yield(get_tree().create_timer(1),"timeout")
		$CLUI/DiceSet.show_diceset()
		yield(get_tree().create_timer(.5),"timeout")
		show_states_button()
	elif current_state == GameState.ACTIONS:
		$CLUI/DiceSet.roll_all_dices()
		yield($CLUI/DiceSet,"end_all_rolls")
		disable_dices_click = false
		show_states_button()
	elif current_state == GameState.ATTACKS:
		disable_dices_click = true
		$CLUI/DiceSet.get_dice_parts()
		yield($CLUI/DiceSet,"end_dice_part_collect")
		yield(get_tree().create_timer(.2),"timeout")
		while true:
			var army = $CLUI/PlayerActionList.get_and_hide_first_army()
			if army:
				ArmyManager.run_army_action(army)
				yield(ArmyManager,"end_army_action")
			else: break
		yield(get_tree().create_timer(.7),"timeout")
		change_state(GameState.ENEMIES)
	elif current_state == GameState.ENEMIES:
		yield(get_tree().create_timer(.5),"timeout")
		Effector.show_float_text("ENEMIES TURN!")
		yield(get_tree().create_timer(.5),"timeout")
		for en in EnemyManager.re_ordered_enemies_array():
			en.move()
			yield(en,"end_move")
		yield(get_tree().create_timer(.5),"timeout")
		change_state(GameState.WAVE)
	elif current_state == GameState.WAVE:
		if ($CLUI/WaveUI.WAVE.size()<=0 
		&& EnemyManager.ENEMIES_ACTIVES.size()<=0): 
			$CLUI/UpgradePopup.show_popup()
			yield($CLUI/UpgradePopup,"on_hide_popup")
			yield(get_tree().create_timer(1),"timeout")
			$CLUI/WaveUI.next_wave()
			yield(get_tree().create_timer(2.5),"timeout")
		$CLUI/WaveUI.advance_wave()
		yield(get_tree().create_timer(1.0),"timeout")
		change_state(GameState.START)

func on_button_states():
	var new_state = current_state + 1
	if new_state >= GameState.keys().size(): new_state = 0
	change_state(new_state)

func on_button_hacks():
	$CLUI/Hacks.visible = !$CLUI/Hacks.visible 

func hide_states_button():
	$CLUI/ButtonStates.disabled = true
	Effector.disappear($CLUI/ButtonStates)

func show_states_button():
	$CLUI/ButtonStates.disabled = false
	if current_state==GameState.START: $CLUI/ButtonStates.text = "ROLL"
	elif current_state==GameState.ACTIONS: $CLUI/ButtonStates.text = "END"
	Effector.appear($CLUI/ButtonStates)

func on_click_dice(dice):
	if disable_dices_click:
		Effector.show_float_text("disabled_dices_click")
		return
	if dice.value==-1: 
		Effector.show_float_text("disabled_dice")
		return
	$CLUI/ButtonStates.disabled = true
	disable_dices_click = true
	$CLUI/Belt.move_pawn(dice.value)
	yield($CLUI/Belt,"end_move")
	$CLUI/Belt.current_slot.set_lighted(true)
	yield(get_tree().create_timer(.3),"timeout")
	if $CLUI/Belt.current_slot.reduce_amount():
		$CLUI/PlayerActionList.add_army($CLUI/Belt.current_slot.army)
	$CLUI/Belt.clear_selected_slot()
	dice.hide_dice()
	yield(get_tree().create_timer(.3),"timeout")
	disable_dices_click = false
	$CLUI/ButtonStates.disabled = false

func set_floor_marks():
	for fn in $Floor.get_children():
		fn.visible = (fn.get_index()<EnemyManager.max_x_pos)
		fn.rect_global_position.x = EnemyManager.end_x_pos + (1600-EnemyManager.end_x_pos) / EnemyManager.max_x_pos * fn.get_index()
		fn.rect_global_position.x -= fn.rect_size.x/2
		if fn.visible: print("fn ",fn.rect_global_position.x)
