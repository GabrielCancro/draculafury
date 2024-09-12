extends Control

enum GameState {GO_DICES,GO_ACTION,END_TURN}
var current_state

func _ready():
	change_state(GameState.GO_DICES)
	$ButtonStates.connect("button_down",self,"on_button_states")
	$ButtonAddEnemy.connect("button_down",EnemyManager,"add_rnd_enemy")
	$ButtonAddDice.connect("button_down",$DiceSet,"add_extra_dice")
	Effector.add_hint($ButtonStates,"ASD")

func on_button_states():
	$ButtonStates.disabled = true
	if current_state == GameState.GO_DICES:
		$DiceSet.roll_next_dice()
		var dice_val = yield($DiceSet.current_dice,"end_roll")
		$Belt.move_pawn(dice_val)
		var army_index = yield($Belt,"end_move")
		current_state == GameState.GO_DICES
		change_state(GameState.GO_ACTION)
	elif current_state == GameState.GO_ACTION:
		$DiceSet.current_dice.set_army($Belt.current_slot.army)
		$Belt.clear_selected_slot()
		yield(get_tree().create_timer(.7),"timeout")
		if $DiceSet.is_all_dices_rolled(): change_state(GameState.END_TURN)
		else: change_state(GameState.GO_DICES)
	elif current_state == GameState.END_TURN:
		yield(get_tree().create_timer(1.5),"timeout")
		while true:
			var army = $DiceSet.get_and_hide_first_dice_army()
			if army:
				ArmyManager.run_army_action(army)
				yield(ArmyManager,"end_army_action")
			else: break
		$DiceSet.restore_all_dices()
		yield(get_tree().create_timer(.7),"timeout")
		change_state(GameState.GO_DICES)

func change_state(new_state):
	current_state = new_state
	$ButtonStates.text = GameState.keys()[current_state]
	$ButtonStates.disabled = false
