extends Control

enum GameState {START,ACTIONS,ATTACKS,ENEMIES,WAVE}
var current_state
var disable_dices_click = true

func _ready():
	change_state(GameState.START)
	$CLUI/ButtonStates.connect("button_down",self,"on_button_states")	
	$CLUI/DiceSet.connect("on_click_dice",self,"on_click_dice")
	$CLUI/PlayerUI.update_stats(PlayerManager.PLAYER_STATS)
	
	$CLUI/ButtonHacks.connect("button_down",self,"on_button_hacks")
	$CLUI/Hacks/ButtonAddEnemy.connect("button_down",get_node("/root/Game/CLUI/WaveUI"),"advance_wave")
	$CLUI/Hacks/ButtonAddDice.connect("button_down",$CLUI/DiceSet,"add_extra_dice")
	$CLUI/Hacks/ButtonAnim.connect("button_down",$Player,"set_random_anim")
	$CLUI/Hacks/ButtonFxDyn.connect("button_down",ArmyManager,"run_army_action",["dynamite"])
	$CLUI/Hacks/ButtonUpgrade.connect("button_down",$CLUI/UpgradePopup,"show_popup")

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
		$CLUI/DiceSet.hide_diceset()
		yield(get_tree().create_timer(1.5),"timeout")
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
		yield(get_tree().create_timer(1.5),"timeout")
		change_state(GameState.WAVE)
	elif current_state == GameState.WAVE:
		get_node("/root/Game/CLUI/WaveUI").advance_wave()
		yield(get_tree().create_timer(1.5),"timeout")
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
	disable_dices_click = true
	$CLUI/Belt.move_pawn(dice.value)
	yield($CLUI/Belt,"end_move")
	$CLUI/Belt.current_slot.set_lighted(true)
	yield(get_tree().create_timer(.3),"timeout")
	$CLUI/PlayerActionList.add_army($CLUI/Belt.current_slot.army)
	$CLUI/Belt.clear_selected_slot()
#	if dice.value == 6: 
#		Effector.shake(dice)
#		yield(get_tree().create_timer(.2),"timeout")
#		dice.roll()
#		yield(get_tree().create_timer(.7),"timeout")
#	else:
	dice.hide_dice()
	yield(get_tree().create_timer(.3),"timeout")
	disable_dices_click = false
