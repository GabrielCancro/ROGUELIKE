extends Node2D

var all_habs={}
var array_all_codes=[]

func _ready():
	add_hab("BERSERK",{"icon":0, "name": "Berserker", "type":"PAS", "max":1,
	                  "desc": "+1 danio, 30% de recibir danio extra"})
	add_hab("PUNTERIA",{"icon":0, "name": "Punteria", "type":"PAS", "max":5,
		                "desc": "+1/2/3/4/5 atk con proyectiles"})
	add_hab("ARQUERIA",{"icon":0, "name": "Arqueria", "type":"ACT", "max":1,
		                "desc": "Permite disparar proyectiles"})
	add_hab("ESQUIVA",{"icon":0, "name": "Esquiva", "type":"PAS", "max":3,
		                "desc": "+10/20/30% de esquivar un golpe"})
	#spells
	add_hab("DEBILITAR", {"icon":0, "name": "Debilitar", "type":"SPL", "max":1, "cost":1,
		                "desc": "Reduce el [atk] del objetivo"})
	add_hab("IMPACTO", {"icon":0, "name": "Impacto Magico", "type":"SPL", "max":5, "cost":1,
		                "desc": "Golpea magicamente al enemigo"})
	

func add_hab(CODE,HAB):
	HAB["code"]=CODE
	HAB["cost"]=HAB.get("cost",0)
	HAB["cnt"]=HAB.get("cnt",0)
	all_habs[CODE]=HAB
	array_all_codes.append(CODE)

func getHab(CODE): return all_habs[CODE]

func ejecutarHab(own,data):
	if data["hab"]=="ARQUERIA": own.showSelectorTilePos(data)

func ejecutarSpell(own,data):
	if data["spell"]=="DEBILITAR": own.showSelectorTilePos(data)
	if data["spell"]=="IMPACTO": own.showSelectorTilePos(data)

func ejecutarHabInPos(own,data):	
	var wPos=Globals.tile_map.map_to_world(data["tilePos"])+Globals.tile_map.cell_size/2
	if data["hab"]=="ARQUERIA":
		var hay_obstaculos=Globals.DDCORE.no_obstacles_in(own.TILEABLE.get_tile_pos(),data["tilePos"])
		if hay_obstaculos: 
			var enem=Globals.TilemapManager.get_element(data["tilePos"],"ENEMIES")
			var PUNTERIA=own.ABILITYABLE.get_full_hab("PUNTERIA")
			if enem!=null: Globals.DDCORE.ataque_anonimo(50+PUNTERIA*10,PUNTERIA,enem)
			Globals.turnController.finishTurn(own)
		else: Globals.effectManager.custom_text_effect(wPos,"LIFE", "HAY OBSTACULOS EN MEDIO")
	yield(get_tree().create_timer(.5), "timeout")
	own.setState("MOVE")

func ejecutarSpellInPos(own,data):
	var enem_casting=check_speel_cast_to_enem(own,data["spell"],data["tilePos"])
	if enem_casting==null: 
		own.setState("MOVE")
		return false
	var wPos=Globals.tile_map.map_to_world(data["tilePos"])+Globals.tile_map.cell_size/2
	print(data)
	if data["spell"]=="DEBILITAR":
		Globals.effectManager.magic_effect(wPos)
		yield(get_tree().create_timer(.7), "timeout")
		enem_casting.get_node("Sprite").set_scale(Vector2(.8,.8))
		enem_casting.ATTRIBUTABLE.add_attr("atk",-2)
		Globals.effectManager.text_effect(wPos,"< Debilitado >")
		Globals.GUI.add_info_concat("Conjuro   < "+Globals.HabsManager.getHab(data["spell"])["name"]+" >   lanzado a   "+enem_casting.visual_name+"   -2atk")
		Globals.GUI.add_info_line()
		Globals.turnController.finishTurn(own)
	
	if data["spell"]=="IMPACTO":
		Globals.effectManager.magic_effect(wPos)
		yield(get_tree().create_timer(.7), "timeout")
		Globals.DDCORE.ataque_magico(80,data["cnt"],enem_casting)
		Globals.turnController.finishTurn(own)
		
	yield(get_tree().create_timer(.5), "timeout")
	own.setState("MOVE")

func check_speel_cast_to_enem(OWN,SPELL,POS):
	var wPos=Globals.tile_map.map_to_world(POS)+Globals.tile_map.cell_size/2
	
	if OWN.ATTRIBUTABLE.get_attr(".pp")<getHab(SPELL)["cost"]:
		Globals.effectManager.text_effect(wPos,"PP insuficiente")
		return null
		
	var enem=Globals.TilemapManager.get_element(POS,"ENEMIES")
	if enem==null: 
		Globals.effectManager.text_effect(wPos,"no hay objetivo")
		return null
	
	#hay enemigo y tenemos pp suficientes
	OWN.ATTRIBUTABLE.add_attr(".pp",-getHab(SPELL)["cost"])
	return enem