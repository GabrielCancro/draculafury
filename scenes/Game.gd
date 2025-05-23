extends Control

enum GameState {START,ACTIONS,ATTACKS,ENEMIES,WAVE,BELT}
var current_state
var disable_dices_click = true
var tuto_first_kill = true

var skip_tutorial = false
signal end_tuto_sequence

func _ready():
	set_floor_marks()
	var hint_data={"owner":$CLUI/ButtonStates,"panel":null,"code":null,"over_node":"HintNode","callback":null}
	Effector.add_hint(hint_data)
	if EnemyManager.forced_dracula_wave: skip_tutorial = true
	EnemyManager.initialize_data()
	PlayerManager.initialize_data()
	ItemManager.initialize_data()
	$CLUI/TutorialBlocker.visible = false
	$CLUI/ButtonStates.disabled = true
	$CLUI/ButtonStates.modulate.a = 0
	$CLUI/ButtonStates.connect("button_down",self,"on_button_states")	
	$CLUI/DiceSet.connect("on_click_dice",self,"on_click_dice")
	$CLUI/PlayerUI.update_stats(PlayerManager.PLAYER_STATS)
	$CLUI/UpgradePopup.connect("on_hide_popup",$CLUI/Belt,"update_belt")
	#$CLBG/background.texture = load("res://assets/backgrounds/bg"+str(LevelManager.current_level)+".jpg")
	
	$CLUI/Hacks.visible = false
	$CLUI/ButtonHacks.connect("button_down",self,"on_button_hacks")
	$CLUI/Hacks/ButtonAddEnemy.connect("button_down",get_node("/root/Game/CLUI/WaveUI"),"advance_wave")
	$CLUI/Hacks/ButtonAddDice.connect("button_down",$CLUI/DiceSet,"add_extra_dice")
	$CLUI/Hacks/ButtonAnim.connect("button_down",$Player,"set_random_anim")
	$CLUI/Hacks/ButtonFxDyn.connect("button_down",ArmyManager,"run_army_action",["dynamite"])
	$CLUI/Hacks/ButtonUpgrade.connect("button_down",$CLUI/UpgradePopup,"show_popup")
	$CLUI/Hacks/ButtonXP.connect("button_down",PlayerManager,"add_xp")
	$CLUI/Hacks/ButtonMovEnemies.connect("button_down",EnemyManager,"force_move_enemy")
	$CLUI/Hacks/ButtonAddItem.connect("button_down",ItemManager,"throw_random_item")
	$CLUI/Hacks/ButtonAWolf.connect("button_down",EnemyManager,"add_enemy",["awolf"])
	
	#$CLUI/Hacks/ButtonScale1.connect("button_down",SizerManager,"rescale_ui",[1])
	#$CLUI/Hacks/ButtonScale2.connect("button_down",SizerManager,"rescale_ui",[.9])
	#$CLUI/Hacks/ButtonScale3.connect("button_down",SizerManager,"rescale_ui",[.8])
	#$CLUI/Hacks/ButtonScale4.connect("button_down",SizerManager,"rescale_ui",[.7])
	#$CLUI/Hacks/ButtonScale4.connect("button_down",SizerManager,"rescale_ui",[.6])
	#$CLUI/Hacks/ButtonScale4.connect("button_down",SizerManager,"rescale_ui",[.6])
	
	$CLUI/Hacks/ButtonQuit.connect("button_down",self,"goto_menu")
	$CLUI/Hacks/ButtonOptions.connect("button_down",PopupManager,"show_popup",["options"])
	$CLUI/Hacks/ButtonRotateBelt.connect("button_down",get_node("/root/Game/CLUI/Belt"),"rotate_belt")
	$CLUI/TutorialPopup.connect("skip_tutorial",self,"on_skip_tutorial")
	
	UpgradesManager.apply_upgrades()
	yield(UpgradesManager,"end_apply_upgrades")
	tutorial_sequence()
	
	yield(get_tree().create_timer(1.5),"timeout")
	Sounds.play_music("game")

func change_state(new_state):
	current_state = new_state
	print("NEW STATE ",GameState.keys()[current_state])
	hide_states_button()
	if current_state == GameState.START:
		Effector.show_float_text("player_turn")
		yield(get_tree().create_timer(1),"timeout")
		$CLUI/DiceSet.show_diceset()
		yield(get_tree().create_timer(.5),"timeout")
		show_states_button()
	elif current_state == GameState.ACTIONS:
		$CLUI/DiceSet.roll_all_dices()
		yield($CLUI/DiceSet,"end_all_rolls")
		disable_dices_click = false
		ItemManager.enable_items_usage(true)
		show_states_button()
	elif current_state == GameState.ATTACKS:
		disable_dices_click = true
		$CLUI/DiceSet.block_clicks()
		ItemManager.enable_items_usage(false)
		yield(get_tree().create_timer(.2),"timeout")
		ItemManager.clear_floor_items()
#		$CLUI/DiceSet.get_dice_parts()
#		yield($CLUI/DiceSet,"end_dice_part_collect")
		yield(get_tree().create_timer(.2),"timeout")
		while true:
			var is_army_powered = $CLUI/PlayerActionList.is_first_army_powered()
			var army = $CLUI/PlayerActionList.get_and_hide_first_army()
			if army:
				ArmyManager.run_army_action(army,is_army_powered)
				yield(ArmyManager,"end_army_action")
				if PlayerManager.PLAYER_STATS.kills==1 && SaveManager.savedData.level==1:
					$CLUI/TutorialPopup.show_popup("deadenemy")
					yield($CLUI/TutorialPopup,"close_popup")
			else: break
		yield(get_tree().create_timer(.7),"timeout")
		
		#LEVEL UP
		if PlayerManager.check_level_up():
			if SaveManager.savedData.level==1: 
				$CLUI/TutorialPopup.show_popup("levelup")
				yield($CLUI/TutorialPopup,"close_popup")
			else: 
				yield(get_tree().create_timer(2),"timeout")
		change_state(GameState.ENEMIES)
		
	elif current_state == GameState.ENEMIES:
		yield(get_tree().create_timer(.5),"timeout")
		Effector.show_float_text("enemy_turn")
		yield(get_tree().create_timer(.5),"timeout")
		for en in EnemyManager.re_ordered_enemies_array():
			en.move()
			yield(en,"end_move")
		yield(get_tree().create_timer(.5),"timeout")
		change_state(GameState.WAVE)
	elif current_state == GameState.WAVE:
		if ($CLUI/WaveUI.WAVE.size()<=0 
		&& EnemyManager.ENEMIES_ACTIVES.size()<=0):
			if($CLUI/WaveUI.ALL_WAVES.size()>0):
				$CLUI/UpgradePopup.show_popup()
				yield($CLUI/UpgradePopup,"on_hide_popup")
				yield(get_tree().create_timer(1),"timeout")
				$CLUI/WaveUI.next_wave()
				yield(get_tree().create_timer(2.5),"timeout")
				if UpgradesManager.have_upgrade("amulet"):
					yield(get_tree().create_timer(.5),"timeout")
					Effector.show_float_text("upg_amulet_name")
					yield(get_tree().create_timer(.2),"timeout")
					PlayerManager.heal(1)
					yield(get_tree().create_timer(.5),"timeout")
			else: 
				$CLUI/WinPopup.show_popup()
				return
		$CLUI/WaveUI.advance_wave()
		yield(get_tree().create_timer(.7),"timeout")
		change_state(GameState.BELT)
	elif current_state == GameState.BELT:
		yield(get_tree().create_timer(1),"timeout")
		$CLUI/Belt.rotate_belt()
		var next_dice = $CLUI/DiceSet.get_next_enable_dice()
		while next_dice:
			yield(get_tree().create_timer(.5),"timeout")
			next_dice.block_dice()
			$CLUI/Belt.rotate_belt()
			next_dice = $CLUI/DiceSet.get_next_enable_dice()
		yield(get_tree().create_timer(.5),"timeout")
		$CLUI/DiceSet.hide_diceset()
		yield(get_tree().create_timer(1),"timeout")
		change_state(GameState.START)

func on_button_states():
	Sounds.play_sound("button1")
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
	if current_state==GameState.START: $CLUI/ButtonStates/Label.text = "ROLL"
	elif current_state==GameState.ACTIONS: $CLUI/ButtonStates/Label.text = "END"
	$CLUI/ButtonStates/HintNode/Label2.text = $CLUI/ButtonStates/Label.text
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
	dice.block_dice()
	yield($CLUI/Belt,"end_move")
	$CLUI/Belt.current_slot.set_lighted(true)
	yield(get_tree().create_timer(.3),"timeout")
	if $CLUI/Belt.current_slot.reduce_amount():
		var powered = ($CLUI/Belt.current_slot.get_index()==2)
		$CLUI/PlayerActionList.add_army($CLUI/Belt.current_slot.army,powered)
	$CLUI/Belt.clear_selected_slot()
	yield(get_tree().create_timer(.3),"timeout")
	disable_dices_click = false
	$CLUI/ButtonStates.disabled = false

func set_floor_marks():
	for fn in $Floor.get_children():
		fn.visible = (fn.get_index()<EnemyManager.max_x_pos)
		fn.rect_global_position.x = EnemyManager.end_x_pos + (1920-EnemyManager.end_x_pos) / EnemyManager.max_x_pos * fn.get_index()
		fn.rect_global_position.x -= fn.rect_size.x/2
		if fn.visible: print("fn ",fn.rect_global_position.x)

func goto_menu():
	Effector.change_scene_transition("Menu")

func tutorial_sequence():
	if SaveManager.savedData.level>1: skip_tutorial = true
	if !skip_tutorial:
		$CLUI/WaveUI.first_tuto_enemy = true
		$CLUI/TutorialBlocker.visible = true
		yield(get_tree().create_timer(3),"timeout")
		$CLUI/TutorialPopup.show_popup("welcome")
		yield($CLUI/TutorialPopup,"close_popup")
	
	yield(get_tree().create_timer(.5),"timeout")
	$CLUI/WaveUI.next_wave()
	yield(get_tree().create_timer(2),"timeout")
	$CLUI/WaveUI.advance_wave()
	yield(get_tree().create_timer(2),"timeout")
	if skip_tutorial && current_state!=GameState.START: change_state(GameState.START)
	
	if skip_tutorial: return
	$CLUI/TutorialPopup.show_popup("enemy")
	yield($CLUI/TutorialPopup,"close_popup")
	if skip_tutorial: return
	
	yield(get_tree().create_timer(1),"timeout")
	$CLUI/TutorialPopup.show_popup("belt")
	yield($CLUI/TutorialPopup,"close_popup")
	if skip_tutorial: return
	
	change_state(GameState.START)
	yield(get_tree().create_timer(2),"timeout")
	$CLUI/TutorialPopup.show_popup("dices")
	yield($CLUI/TutorialPopup,"close_popup")
	if skip_tutorial: return
	
	on_button_states()
	yield(get_tree().create_timer(1.25),"timeout")
	$CLUI/DiceSet/HBoxDices/Dice1.force(3)
	$CLUI/DiceSet/HBoxDices/Dice2.force(5)
	
	yield(get_tree().create_timer(1),"timeout")
	$CLUI/TutorialPopup.show_popup("result")
	yield($CLUI/TutorialPopup,"close_popup")
	if skip_tutorial: return
	yield(get_tree().create_timer(0.5),"timeout")
	on_click_dice($CLUI/DiceSet/HBoxDices/Dice1)
	
	yield(get_tree().create_timer(3),"timeout")
	$CLUI/TutorialPopup.show_popup("end")
	yield($CLUI/TutorialPopup,"close_popup")
#	if skip_tutorial: return
#	yield(get_tree().create_timer(.2),"timeout")
#	$CLUI/TutorialPopup.show_popup("diceparts")
#	yield($CLUI/TutorialPopup,"close_popup")
	if skip_tutorial: return
	on_button_states()
	
	yield(get_tree().create_timer(9),"timeout")
	$CLUI/TutorialPopup.show_popup("startgame")
	yield($CLUI/TutorialPopup,"close_popup")
	if skip_tutorial: return
	$CLUI/TutorialBlocker.visible = false
	#emit_signal("end_tuto_sequence")

func on_skip_tutorial():
	if skip_tutorial: return
	skip_tutorial = true
	$CLUI/TutorialBlocker.visible = false
	if current_state==null: 
		if $CLUI/WaveUI.WAVE.size()==0: yield(get_tree().create_timer(6),"timeout")
		if current_state!=GameState.START: change_state(GameState.START)
	return
