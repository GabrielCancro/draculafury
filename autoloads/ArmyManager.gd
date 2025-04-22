extends Node

signal end_army_action()
var powered = false #if the current army is in the middle of belt!


# TAGS ability damage largerange shortrange multitarget 
# TAGS ammunition enlist exhaustible restricted
var ARMIES = {
	"breathe":{"tags":["ability"]},
	"kick":{"tags":["damage","shortrange"],"damage":"6"},
	"rapier":{"tags":["damage","shortrange","multitarget"],"damage":"6/3"},
	"gun":{"tags":["damage","ammunition"],"damage":"3", "amount":3},
	"shotgun":{"tags":["damage","multitarget","ammunition"],"damage":"6/3", "amount":2},
	"crossbow":{"tags":["damage","largerange","ammunition"],"damage":"6", "amount":3},
	"stake":{"tags":["damage","exhaustible"],"damage":"8"},
	"dynamite":{"tags":["damage","multitarget","exhaustible"],"damage":"6"},
	"trap":{"tags":["damage","restricted"],"damage":"6"},
}

var PLAYER
var ArmyTrapNode

func get_army_data(code):
	var army_data = ARMIES[code].duplicate()
	army_data["name"] = code
	return army_data

func get_random_army():
	randomize()
	var i = randi()%ARMIES.keys().size()
	return ARMIES.keys()[i]

func run_army_action(code):
	#Effector.show_float_text(code)
	powered = (code==get_node("/root/Game/CLUI/Belt/HBox").get_child(2).army)
	print("IS POWERED ARMY!! ",code,"  ",powered)
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
		en.add_stun()
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
	var fxdyn = load("res://nodes/fx/fx_dynamite.tscn").instance()
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
	if !"amount" in ARMIES[code]: return null
	var amount = ARMIES[code]["amount"]
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

func have_tag(code,tag):
	if !"tags" in ARMIES[code]: return false
	if !tag in ARMIES[code]["tags"]: return false
	return true
