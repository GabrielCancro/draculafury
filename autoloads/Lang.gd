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
	"army_rapier_desc_es":"Alcance 2, Daño 2, a todos los enemigos de la primera y segunda casilla, incluso voladores.",
	"army_gun_desc_es":"Largo alcance, Daño 1, al primer enemigo, incluso si está volando.",
	"army_shotgun_desc_es":"Largo alcance, Daños 2, al primer enemigo incluso si esta volando, además causa 1 daño al siguiente enemigo.",
	"army_crossbow_desc_es":"Largo alcance, Daño 2, al primer enemigo que esté volando. Si no hay voladores, 1 daño al primer enemigo.",
	"army_stake_desc_es":"Largo alcance, Daño 3, primer enemigo, incluso si esta volando.",
	"army_dynamite_desc_es":"Daño en area, Daño 2, a todos los enemigos, incluso voladores.",
	
	"ui_end_wave_es":"Fin de Oleada!",
	"ui_upg_new_army_es":"Elige un espacio de tu cinturon para colocar tu arma nueva, si está ocupado será reemplazado.",
	"ui_no_item_face_es":"No puedes usar items ahora.",
	"ui_player_extra_dice_es":"Dado extra",
	"ui_max_dices_es":"Máximo de dados alcanzado!",
	"ui_levelup_es":"Has pasado de nivel..\n\n + Ahora eres mas reconocido, ganas un punto de equipamiento para tu próxima partida.\n\n + Ahora eres mas habilidoso, ganas un dado extra para el resto de esta partida.",
	"ui_level_es":"Nivel",
	"player_turn_es":"ES TU TURNO",
	"enemy_turn_es":"TURNO DE LOS ENEMIGOS",

	"en_vampire_name_es":"Vampiro",
	"en_vampire_desc_es":"Un asqueroso vampiro en busca de sangre.",
	"en_bat_name_es":"Murcielago",
	"en_bat_desc_es":"Este murcielago no es solo una rata con alas, parece peligroso.",
	"en_wolf_name_es":"Lobo",
	"en_wolf_desc_es":"Un hambriento lobo dominado por el frenesí.",
	"en_gargoyle_name_es":"Gargola",
	"en_gargoyle_desc_es":"Rocosa criatura alada.",
	
	"en_ab_extra_mov_desc_es":"Movimiento Extra: tiene 30% de posibilidad de avanzar un casillero extra en su turno.",
	"en_ab_stone_skin_desc_es":"Piel Petrea: su dura piel absorbe todo el daño del primer ataque recibido en cada turno.",
	
	"it_crucifix_name_es":"Crucifijo",
	"it_crucifix_desc_es":"Todos los enemigos reciben un punto de daño.",
	"it_garlic_name_es":"Ajo",
	"it_garlic_desc_es":"Recuperas 2 puntos de daño.",
	"it_ron_name_es":"Ron",
	"it_ron_desc_es":"Vuelve a utilizar el arma que indica la mano en tu cinturón de armas.",
	"it_dice_name_es":"Dado",
	"it_dice_desc_es":"Añade un dado extra a tu tirada.",
	
	"tuto_all_es":"Lazna tus dados y elige cual utilizar, esto moverá tu mano en el cinturón de armas para utilizarlas!\nSi sacas algún 6 (seis) obtendrás un dado extra!!\n\nLos enemigos intentarán dañarte, evitalo a toda costa!\nAl destruirlos ganarás experiencia.",
	"win_game_es":"Has ganado! Es hora de recuperar fuerzas y prepararte para la siguiente jornada!",
	"msg_level_up_es":"Has pasado de nivel!",
	"level_name_1_es":"La Tumba",
	"level_name_2_es":"La Catedral",
	"level_name_3_es":"El Pantano",
	"level_name_4_es":"La Aldea",
	"level_name_5_es":"El Castillo",
	
	"upg_life_es": "Un objeto que por el momento no hace ni sirve para nada.",
	
	"menu_start_es":"Comenzar",
	"menu_start_en":"Start",
	"menu_lang_es": "Idioma: Español",
	"menu_lang_en": "Lang: English",
	
	"prestart_title_es":"Prepara tu\n   equipo inicial..",
	"prestart_end_es":"Continuar",
	
	"upg1_desc_es":"MEJORA 01: Descripcion de la mejora, cosas que hace y beneficios que otorga y beneficios que otorga y beneficios que otorga y beneficios que otorga.",
	"upg2_desc_es":"MEJORA 02: Descripcion de la mejora, cosas que hace y beneficios que otorga.",
	"upg3_desc_es":"MEJORA 03: Descripcion de la mejora, cosas que hace y beneficios que otorga.",
	"upg4_desc_es":"MEJORA 04: Descripcion de la mejora, cosas que hace y beneficios que otorga.",
	"upg5_desc_es":"MEJORA 05: Descripcion de la mejora, cosas que hace y beneficios que otorga.",
	"upg6_desc_es":"MEJORA 06: Descripcion de la mejora, cosas que hace y beneficios que otorga.",
	"upg7_desc_es":"MEJORA 07: Descripcion de la mejora, cosas que hace y beneficios que otorga.",
	
	"tuto_welcome_es":"Bienvenido Cazador,\nTe estabamos esperando. Drácula ha despertado y sus criaturas rondan por todos lados, no perdamos el tiempo!",
	"tuto_enemy_es":"Menos mal que estas aquí! Ese vampiro intentará matarte, utiliza las armas de tu cinturón para terminar con él.",
	"tuto_belt_es":"Este es tu cinturón de armas, aqui tienes todas tus herramientas para terminar con la peste de Drácula. Ahora veremos como funciona.",
	"tuto_dices_es":"Lo primero es arrojar tus dados, esto te permitira mover tu \"mano\" por el cinturón para escoger un arma.\nDale al botón de ROLL.",
	"tuto_result_es":"Muy bien, al clickear esos dados tu mano avanzará por el cinturón y activarás la casilla en la que caigas, intenta utilizar tu primer dado..",
	"tuto_end_es":"Has activado tu revolver! Ahora finaliza tu turno presionando el boton de finalizar para realizar tu acción.",
	"tuto_diceparts_es":"Los dados que no hayas utilizado te darán un poco de experiencia.",
	"tuto_startgame_es":"Ahora si. Acaba con ellos!!",
	"tuto_getsix_es":"Cada vez que saques un SEIS en algún dado obtienes un dado extra!",
	"tuto_deadenemy_es":"Cuando vences a un enemigo ganas experiencia. Al pasar de nivel podrás desbloquear beneficios para tu proxima travesía!",
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

func change_lang():
	if lang=="en": lang = "es"
	else: lang = "en"
