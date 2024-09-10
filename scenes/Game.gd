extends Control

enum GameState {GO_DICES,GO_ACTION,END_TURN}
var current_state

func _ready():
	change_state(GameState.GO_DICES)
	$ButtonStates.connect("button_down",self,"on_button_states")
	$ButtonAddEnemy.connect("button_down",EnemyManager,"add_enemy",["goblin"])

func on_button_states():
	$ButtonStates.disabled = true
	if current_state == GameState.GO_DICES:
		$Dice.roll()
		var dice_val = yield($Dice,"end_roll")
		$Belt.move_pawn(dice_val)
		var army_index = yield($Belt,"end_move")
		current_state == GameState.GO_DICES
		change_state(GameState.GO_ACTION)
	elif current_state == GameState.GO_ACTION:
		$Belt.run_action()
		yield($Belt,"end_action")
		change_state(GameState.END_TURN)
	elif current_state == GameState.END_TURN:
		yield(get_tree().create_timer(1),"timeout")
		change_state(GameState.GO_DICES)

func change_state(new_state):
	current_state = new_state
	$ButtonStates.text = GameState.keys()[current_state]
	$ButtonStates.disabled = false
