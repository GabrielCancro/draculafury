extends Control

enum GameState {START,ACTIONS,ATTACKS,ENEMIES}
var current_state
var disable_dices_click = true

func _ready():
	change_state(GameState.START)
	$CLUI/ButtonStates.connect("button_down",self,"on_button_states")
	$CLUI/ButtonAddEnemy.connect("button_down",EnemyManager,"add_rnd_enemy")
	$CLUI/ButtonAddDice.connect("button_down",$CLUI/DiceSet,"add_extra_dice")
	$CLUI/DiceSet.connect("on_click_dice",self,"on_click_dice")
	Effector.add_hint($CLUI/ButtonStates,"ASD")
	$CLUI/PlayerUI.update_stats(PlayerManager.PLAYER_STATS)

func change_state(new_state):
	current_state = new_state
	print("NEW STATE ",GameState.keys()[current_state])
	hide_states_button()
	if current_state == GameState.START:
		Effector.show_float_text("PLAYER TURN!")
		yield(get_tree().create_timer(1),"timeout")
		$CLUI/DiceSet.restore_all_dices()
		yield(get_tree().create_timer(.5),"timeout")
		$CLUI/ButtonAddDice.visible = true
		show_states_button()
	if current_state == GameState.ACTIONS:
		$CLUI/DiceSet.roll_all_unrolled_dices()
		$CLUI/ButtonAddDice.visible = false
		yield(get_tree().create_timer(1.5),"timeout")
		disable_dices_click = false
		show_states_button()
	if current_state == GameState.ATTACKS:
		disable_dices_click = true
		yield(get_tree().create_timer(1.5),"timeout")
		while true:
			var army = $CLUI/DiceSet.get_and_hide_first_dice_army()
			if army:
				ArmyManager.run_army_action(army)
				yield(ArmyManager,"end_army_action")
			else: break
		yield(get_tree().create_timer(.7),"timeout")
		change_state(GameState.ENEMIES)
	if current_state == GameState.ENEMIES:
		yield(get_tree().create_timer(.5),"timeout")
		Effector.show_float_text("ENEMIES TURN!")
		yield(get_tree().create_timer(.7),"timeout")
		yield(get_tree().create_timer(.5),"timeout")
		for en in EnemyManager.re_ordered_enemies_array():
			en.move()
			yield(en,"end_move")
		yield(get_tree().create_timer(2.0),"timeout")
		change_state(GameState.START)

func on_button_states():
	var new_state = current_state + 1
	if new_state >= GameState.keys().size(): new_state = 0
	change_state(new_state)

func hide_states_button():
	$CLUI/ButtonStates.disabled = true
	Effector.disappear($CLUI/ButtonStates)

func show_states_button():
	$CLUI/ButtonStates.disabled = false
	if current_state==GameState.START: $CLUI/ButtonStates.text = "ROLL DICES"
	elif current_state==GameState.ACTIONS: $CLUI/ButtonStates.text = "ATTACK!!"
	Effector.appear($CLUI/ButtonStates)

func on_click_dice(dice):
	if disable_dices_click:
		Effector.show_float_text("disabled_dices_click")
		return
	if dice.army or dice.value==-1: return
	disable_dices_click = true
	$CLUI/Belt.move_pawn(dice.value)
	yield($CLUI/Belt,"end_move")
	$CLUI/Belt.current_slot.set_lighted(true)
	yield(get_tree().create_timer(.3),"timeout")
	dice.set_army($CLUI/Belt.current_slot.army)
	$CLUI/PlayerActionList.add_army($CLUI/Belt.current_slot.army)
	$CLUI/Belt.clear_selected_slot()
	yield(get_tree().create_timer(.3),"timeout")
	disable_dices_click = false
