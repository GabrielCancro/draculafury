extends Node

var lang = "es"

var texts = {
	"roll_dice_es": "Estar tirando un dado!!",
	"army_breathe_name_es":"Respiro",
	"army_kick_name_es":"Patada",
	"army_rapier_name_es":"Estoque",
	"army_gun_name_es":"Pistola",
	"army_shotgun_name_es":"Escopeta",
	"army_crossbow_name_es":"Ballesta",
	"army_stake_name_es":"Estaca",
	"army_dynamite_name_es":"Dinamita",

	"army_breathe_desc_es":"Recupera un punto de salud. No puede usarse si hay un enemigo cerca.",
	"army_kick_desc_es":"Alcance 2, Daño 2, y empuja hacia atrás al enemigo.",
	"army_rapier_desc_es":"Alcance 2, Daño 2, tambien daña al al enemigo que este arriba o abajo del objetivo.",
	"army_gun_desc_es":"Largo alcance, Daño 1, al primer enemigo, incluso si está volando.",
	"army_shotgun_desc_es":"Largo alcance, Daños 2, al primer enemigo incluso si esta volando, además causa 1 daño a los enemigos adyacentes.",
	"army_crossbow_desc_es":"Largo alcance, Daño 2, al primer enemigo que esté volando. Solo sirve contra enemigos voladores.",
	"army_stake_desc_es":"Largo alcance, Daño 10, primer enemigo, incluso si esta volando.",
	"army_dynamite_desc_es":"Daño en area, Daño 5, a todos los enemigos, incluso voladores.",
	
	"ui_end_wave_es":"Fin de Oleada!",
	"ui_upg_new_army_es":"Elige un espacio de tu cinturon para colocar tu arma nueva, si está ocupado será reemplazado.",

	"en_vampire_name_es":"Vampiro",
	"en_vampire_desc_es":"Un asqueroso vampiro en busca de sangre.",
	"en_bat_name_es":"Murcielago",
	"en_bat_desc_es":"Este murcielago no es solo una rata con alas, parece peligroso.",

	"en_ab_extra_mov_desc_es":"Movimiento Extra: tiene 30% de posibilidad de avanzar un casillero extra en su turno.",
	"tuto_dices_es":"Lanza tus dados y elige el orden, esto moverá tu mano en el cinturón de armas para utilizarlas.\nPor cada 6 (seis) obtendrás un dado extra!!",
	"tuto_enemies_es":"Los enemigos intentarán dañarte, evitalo a toda costa.\nAl destruirlos ganarás experiencia.",
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
