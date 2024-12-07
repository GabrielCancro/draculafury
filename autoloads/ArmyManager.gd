extends Node

signal end_army_action()

var ARMIES = ["breathe","kick","rapier","gun","shotgun","crossbow","stake","dynamite"]
var ARMIES_AMOUNT = {"gun":3,"shotgun":2,"crossbow":3,"stake":1,"dynamite":1}
var PLAYER
var ArmyTrapNode

func get_army_data(code):
	var army_data = {"name":code,"amount":-1}
	if code in ARMIES_AMOUNT: army_data.amount = ARMIES_AMOUNT[code]
	return army_data

func get_random_army():
	randomize()
	var i = randi()%ARMIES.size()
	return ARMIES[i]

func run_army_action(code):
	#Effector.show_float_text(code)
	yield(get_tree().create_timer(.2),"timeout")
	if !PLAYER: PLAYER = get_node("/root/Game/Player")
	if has_method("_condition_"+code) && !call("_condition_"+code):
		Effector.show_float_text("ui_no_effect")
		yield(get_tree().create_timer(.5),"timeout")
		emit_signal("end_army_action")
	else:
		PLAYER.set_anim(code)
		Sounds.play_sound("army_"+code)
		yield(PLAYER,"end_anim")
		call("_run_"+code)

func _condition_breathe(): return !EnemyManager.have_close_enemy(1) && PlayerManager.PLAYER_STATS.hp<PlayerManager.PLAYER_STATS.hpm
func _run_breathe():
	PlayerManager.heal(1)
	if UpgradesManager.have_upgrade("cigarettes"): PlayerManager.heal(1)
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("end_army_action")

func _condition_kick(): return EnemyManager.have_close_enemy(2,0)
func _run_kick():
	var en = EnemyManager.get_first_enemy(2,0)
	if en:
		en.enemy_damage(1)
		yield(get_tree().create_timer(.7),"timeout")
		EnemyManager.move_to_first_free_space(en,2)
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("end_army_action")

func _condition_rapier(): return EnemyManager.have_close_enemy(2)
func _run_rapier():
	var en = EnemyManager.get_enemy_in_pos(0,0)
	if en: en.enemy_damage(2)
	en = EnemyManager.get_enemy_in_pos(0,1)
	if en: en.enemy_damage(2)
	yield(get_tree().create_timer(.25),"timeout")
	en = EnemyManager.get_enemy_in_pos(1,0)
	if en: en.enemy_damage(2)
	en = EnemyManager.get_enemy_in_pos(1,1)
	if en: en.enemy_damage(2)
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("end_army_action")

func _condition_gun(): return EnemyManager.have_close_enemy()
func _run_gun():
	var en = EnemyManager.get_first_enemy()
	if en:
		if UpgradesManager.have_upgrade("silverbullets") && randi()%100<50:
			Effector.show_float_text("upg_silverbullets_name")
			en.enemy_damage(2)
		else: en.enemy_damage(1)
		yield(get_tree().create_timer(.7),"timeout")
	emit_signal("end_army_action")

func _condition_shotgun(): return EnemyManager.have_close_enemy()
func _run_shotgun():
	var en = EnemyManager.get_first_enemy()
	if en: en.enemy_damage(2)
	var en2 = EnemyManager.get_next_enemy_that(en)
	if en2: 
		yield(get_tree().create_timer(.5),"timeout")
		en2.enemy_damage(1)
	yield(get_tree().create_timer(.7),"timeout")
	emit_signal("end_army_action")
	
func _condition_crossbow(): return EnemyManager.have_close_enemy()
func _run_crossbow():
	var en = EnemyManager.get_first_enemy(99,1)
	if en: en.enemy_damage(2)
	else:
		en = EnemyManager.get_first_enemy(99,0)
		if en: en.enemy_damage(1)
	yield(get_tree().create_timer(.7),"timeout")
	emit_signal("end_army_action")

func _condition_stake(): return EnemyManager.have_close_enemy()
func _run_stake():
	var en = EnemyManager.get_first_enemy()
	if en: en.enemy_damage(3)
	yield(get_tree().create_timer(.7),"timeout")
	emit_signal("end_army_action")

func _condition_dynamite(): return EnemyManager.have_close_enemy()
func _run_dynamite():
	var fxdyn = preload("res://nodes/fx/fx_dynamite.tscn").instance()
	get_node("/root/Game").add_child(fxdyn)
	yield(get_tree().create_timer(.9),"timeout")
	Sounds.play_sound("dynamite_explode")
	yield(get_tree().create_timer(.1),"timeout")
	for en in EnemyManager.ENEMIES_ACTIVES:
		en.enemy_damage(2)
	yield(get_tree().create_timer(.7),"timeout")
	emit_signal("end_army_action")

func _condition_trap(): return true
func _run_trap():
	get_node("/root/Game/ArmyTrapNode").set_trap()
	yield(get_tree().create_timer(.7),"timeout")
	emit_signal("end_army_action")

func get_army_amount(code):
	var amount = -1
	if code in ARMIES_AMOUNT.keys():
		amount = ARMIES_AMOUNT[code]
		if code=="gun" and UpgradesManager.have_upgrade("charger"): amount*=2
	return amount

func check_enemy_in_trap(en):
	if ArmyTrapNode.xpos == en.enemy_data.tile_pos_x:
		yield(get_tree().create_timer(.2),"timeout")
		Sounds.play_sound("army_crossbow")
		ArmyTrapNode.unset_trap()
		en.enemy_damage(2)
		return true
	return false
