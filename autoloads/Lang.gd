extends Node

var lang = "es"
signal change_language()

var texts = {
	"ui_back_es":"Volver",
	"ui_options_es":"Opciones",
	"ui_lang_option_es":"Idioma: Español",
	"ui_clear_data_es":"Borrar datos",
	"ui_quit_es":"Salir",
	"ui_start_es":"Comenzar",
	"ui_fullscreen_es":"Pantalla completa",
	
	"roll_dice_es": "Estar tirando un dado!!",
	"army_breathe_name_es":"Respiro",
	"army_kick_name_es":"Patada",
	"army_rapier_name_es":"Estoque",
	"army_gun_name_es":"Pistola",
	"army_shotgun_name_es":"Escopeta",
	"army_crossbow_name_es":"Ballesta",
	"army_stake_name_es":"Estaca",
	"army_dynamite_name_es":"Dinamita",
	"army_trap_name_es":"Trampa",

	"army_breathe_desc_es":"Da una bocanada de aire que recupera UN punto de Salud. No puede usarse si hay un enemigo cerca.",
	"army_breathe_pow_desc_es":"Da una bocanada de aire que recupera TRES punto de Salud. No puede usarse si hay un enemigo cerca.",
	
	"army_kick_desc_es":"Da una patada que causa UN daño a un enemigo y lo EMPUJA hacia atrás. No afecta a VOLADORES.",
	"army_kick_pow_desc_es":"Da una patada que causa DOS daños a un enemigo y lo EMPUJA, además queda ATURDIDO. No afecta a VOLADORES.",
	
	"army_rapier_desc_es":"Daña a todos los enemigos de la primera y segunda casilla, incluso voladores.",
	"army_rapier_pow_desc_es":"Daña a todos los enemigos de la primera y segunda casilla, incluso voladores. Da un segundo golpe mas débil a los de la primera casilla.",
	
	"army_gun_desc_es":"Hace un disparo que causa UN daño al primer enemigo incluso si esta volando.",
	"army_gun_pow_desc_es":"Hace un disparo que causa UN daño al primer enemigo. Además hace un segundo disparo sin gastar munición.",
	
	"army_shotgun_desc_es":"Hace un disparo que causa DOS daños al primer enemigo y UN daño a un enemigo que esté detrás.",
	"army_shotgun_pow_desc_es":"Hace un disparo que causa CUATRO daños al primer enemigo y DOS daño a un enemigo que esté detrás.",
	
	"army_crossbow_desc_es":"Lanza una flecha que causa DOS daños a un enemigo aleatorio. No puede usarse si hay un enemigo cerca.",
	"army_crossbow_pow_desc_es":"Lanza DOS flechas que causan DOS daños a enemigos aleatorios. No puede usarse si hay un enemigo cerca.",
	
	"army_stake_desc_es":"Lanza una estaca de madera que causa TRES daños al primer enemigo.",
	"army_stake_pow_desc_es":"Lanza una estaca de madera que causa CINCO daños al primer enemigo.",
	
	"army_dynamite_desc_es":"Causa TRES de daño a todos los enemigos. Solo una por cinturón.",
	"army_dynamite_pow_desc_es":"Causa TRES de daño y ATURDE a todos los enemigos. Solo una por cinturón.",
	
	"army_trap_desc_es":"Coloca una trampa en un espacio vacío aleatorio. Al activarse causa DOS daños, luego se recupera la trampa.",
	"army_trap_pow_desc_es":"Coloca una trampa en un espacio vacío aleatorio. Al activarse causa TRES daños y ATURDE al enemigo, luego se recupera la trampa.",
	
	"ui_end_wave_es":"Fin de Oleada!",
	"ui_upg_new_army_es":"Elige un espacio de tu cinturon para sustituirlo y colocar tu arma nueva.",
	"ui_no_item_face_es":"No puedes usar items ahora.",
	"ui_player_extra_dice_es":"Dado extra",
	"ui_max_dices_es":"Máximo de dados alcanzado!",
	"ui_level_es":"Nivel",
	"ui_cost_es":"costo",
	"ui_need_level_es":"Necesitas mas Nivel para desbloquear este objeto. Sigue jugando un poco mas!",
	"ui_need_more_points_es":"No te alcanza!",
	"ui_dont_hope_army_es":"No la necesito",
	"ui_no_effect_es":"SIN EFECTO",
	"player_turn_es":"ES TU TURNO",
	"enemy_turn_es":"TURNO DE LOS ENEMIGOS",

	"en_vampire_name_es":"Vampiro",
	"en_vampire_desc_es":"Una criatura de la noche que se alimenta de sangre, elegante y mortal.",
	"en_bat_name_es":"Murcielago",
	"en_bat_desc_es":"Este murcielago no es solo una rata con alas, parece peligroso.",
	"en_wolf_name_es":"Lobo",
	"en_wolf_desc_es":"Un hambriento lobo dominado por el frenesí.",
	"en_awolf_name_es":"Lobo Alfa",
	"en_awolf_desc_es":"El lobo lider ganó su puesto por algo.",
	"en_gargoyle_name_es":"Gargola",
	"en_gargoyle_desc_es":"Rocosa criatura alada.",
	"en_dracula_name_es":"Dracula",
	"en_dracula_desc_es":"El señor de las bestias esta aquí.",
	
	"en_ab_extra_mov_name_es":"Frenesí",
	"en_ab_extra_mov_desc_es":"Tiene una pequeña probabilidad de moverse un espacio extra en su turno.",
	"en_ab_stone_skin_desc_es":"Piel Petrea: su dura piel absorbe todo el daño del primer ataque recibido en cada turno.",
	"en_ab_wolf_herd_desc_es":"Manada de lobos: en cada turno tiene 50% de probabilidad de convocar a otro lobo.",
	
	"en_dracula_skill_redmoon_es":"Luna Roja: todos los enemigos hacen más daño.",
	"en_dracula_skill_horde_es":"Horda: aparecen hasta tres vampiros más.",
	"en_dracula_skill_shield_es":"Escudo: Tiene un escudo como la gárgola.",
	"en_dracula_skill_beast_es":"Forma de bestia: Volador. Ataque 5, Movimiento 5, Vida 5",
	
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
	"msg_ambush_es":"EMBOSCADA!!",
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
	
	"upg_amulet_name_es":"Amuleto",
	"upg_amulet_desc_es":"Recuperas 1pv al final de cada oleada.",
	"upg_bag_name_es":"Bolso",
	"upg_bag_desc_es":"Empezas con dos items aleatorios.",
	"upg_vest_name_es":"Chaleco",
	"upg_vest_desc_es":"Tenes 4pv extra.",
	"upg_map_name_es":"Mapa",
	"upg_map_desc_es":"Comienzas tu partida en la catedral evitando las primeras oleadas.",
	"upg_cigarettes_name_es":"Cigarros",
	"upg_cigarettes_desc_es":"La habilidad de suspiro cura el doble.",
	"upg_shotgun_name_es":"Recortada",
	"upg_shotgun_desc_es":"Remplaza una de tus pistolas por una escopeta .",
	"upg_gunslot_name_es":"Estuche",
	"upg_gunslot_desc_es":"Comienzas con una pistola en un slot extra de tu cinturón.",
	"upg_charger_name_es":"Cargadores",
	"upg_charger_desc_es":"Las pistolas tienen el doble de municiones.",
	"upg_silverbullets_name_es":"Balas de plata",
	"upg_silverbullets_desc_es":"Las pistolas tienen 50% de hacer el doble de daño.",
	
	
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
	"tuto_levelup_es":"Genial! Has pasado de nivel, cuendo juegues tu proxima partida tendrás objetos y mejoras nuevas para utilizar y obtener algo de ventaja!",
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
	SaveManager.save_store_data()
	emit_signal("change_language")
