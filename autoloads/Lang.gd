extends Node

var lang = "es"

var texts = {
	"roll_dice_es": "Estar tirando un dado!!",
	"army_breathe_es":"Respiro, recupera un punto de salud. No puede usarse si hay un enemigo adyacente.",
	"army_kick_es":"Patada, alcance 2, causa 1 daño y empuja hacia atrás al enemigo.",
	"army_rapier_es":"Estoque, alcance 2, causa 2 daños. Pega al todos los enemigos en la misma linea.",
	"army_gun_es":"Pistola, largo alcance, causa 1 daño al primer enemigo, incluso si está volando.",
	"army_shotgun_es":"Escopeta, largo alcance, causa 2 daños al primer enemigo incluso si esta volando, además causa 1 daño a los enemigos adyacentes.",
	"army_crossbow_es":"Ballesta, largo alcance, causa 2 daños a un enemigo que esté volando. No puede usarse si hay enemigos en la primera linea",
	"army_stake_es":"Estaca, largo alcance, causa 10 daños al primer enemigo, incluso si esta volando. (Solo una por -in_progress-)",
	"army_dynamite_es":"Dinamita, daño en area, causa 5 daños a todos los enemigos. (Solo uno por oleada -in_progress-)",

	"wave_empty_slot_es":"No hay ningun enemigo aquí.",
	"enemy_desc_bat_es":"Murcielago: \nMovimiento 1, Ataque 1, Alcance 1\n Volador",
	"enemy_desc_vampire_es":"Vampiro: \nMovimiento 1, Ataque 1, Alcance 1",
	
	"ui_end_wave_es":"Fin de Oleada!",
	"ui_upg_new_army_es":"Selecciona un slot de tu cinturón para colocar tu nueva arma!",
	
	"en_vampire_name_es":"Vampiro",
	"en_vampire_desc_es":"Un asqueroso vampiro en busca de sangre.",
	"en_bat_name_es":"Murcielago",
	"en_bat_desc_es":"Este murcielago no es solo una rata con alas, parece peligroso.",

	"en_ab_extra_mov_desc_es":"Movimiento Extra: tiene 30% de posibilidad de avanzar un casillero extra en su turno.",
}

var images = {
	"@SW":"[img=15]res://assets/slats/SW.png[/img]",
	"@HP":"[img=15]res://assets/bbimg/bb_hp.png[/img]",
	"@GR":"[img=15]res://assets/slats/GR.png[/img]",
	"@MC":"[img=15]res://assets/bbimg/gear.png[/img]"
}

func get_text(code):
	var lang_code = code+"_"+lang
	if !lang_code in texts: return "<"+lang_code+">"
	else: 
		var tx = texts[lang_code]
		if "@" in tx: 
			for k in images.keys(): tx = tx.replace(k,images[k])
			return "[center]"+tx+"[/center]"
		else: return tx
