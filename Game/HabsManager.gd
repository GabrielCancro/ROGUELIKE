extends Node2D

var all_habs={}
var array_all_codes=[]

func _ready():
	load_habs_file()
##	save_JSON()
	
#func save_JSON():
#	var file = File.new()
#	file.open("user://habs.json", File.WRITE)
#	file.store_string(JSON.print(all_habs))
#	file.close()
	
func load_habs_file():
	var file = File.new()
	file.open("res://JSON/habs.json", File.READ)
	var json = file.get_as_text()
	file.close()
	var json_result = JSON.parse(json).result
	for HAB in json_result:
		print(HAB)
		if HAB!="//": add_hab(HAB,json_result[HAB])
		
func add_hab(CODE,HAB):
	HAB["code"]=CODE
	HAB["cost"]=HAB.get("cost",0)
	HAB["cnt"]=HAB.get("cnt",0)
	all_habs[CODE]=HAB
	array_all_codes.append(CODE)

func getHab(CODE): return all_habs[CODE]

func getDesc(CODE,CNT):
	var HAB=getHab(CODE)
	var TXT=""
	var xNvl=0
	if HAB["max"]>1: xNvl=HAB["xNvl"][CNT-1]	
	TXT+=HAB["desc"].replace("!@", xNvl)
	if(HAB["type"]=="SPL"): TXT+=" -"+str(HAB["cost"])+"pp"
	return TXT

func ejecutarHab(own,data):
	if data["hab"]=="ARQUERIA": own.showSelectorTilePos(data)

func ejecutarSpell(own,data):
	if data["spell"]=="DEBILITAR": own.showSelectorTilePos(data)
	elif data["spell"]=="IMPACTO": own.showSelectorTilePos(data)
	elif data["spell"]=="EXPLOSION": own.showSelectorTilePos(data)
	elif data["spell"]=="OJOMAGICO": 
		if check_pp(own,data["spell"]):
			quit_pp(own,data["spell"])
			Globals.effectManager.sheet_fx("MAGIC",own.position)
			data["tilePos"]=own.TILEABLE.get_tile_pos()
			var rango=8
			yield(get_tree().create_timer(.5), "timeout")
			for x in range(data["tilePos"].x-rango,data["tilePos"].x+rango+1):
				for y in range(data["tilePos"].y-rango,data["tilePos"].y+rango+1):
					if (Vector2(x,y)-data["tilePos"]).length()>rango+1: continue
					Globals.dunGen.fog_map.set_cell(x, y, -1)
			Globals.turnController.finishTurn(own)
		own.setState("MOVE")

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
	if !check_pp(own,data["spell"]):
		own.setState("MOVE")
		return
	
	var wPos=Globals.tile_map.map_to_world(data["tilePos"])+Globals.tile_map.cell_size/2
	var POWER=0
	if getHab(data["spell"])["max"]>1: POWER=getHab(data["spell"])["xNvl"][data["cnt"]-1]
	
	
	if data["spell"]=="DEBILITAR":
		var EN=check_enem(data["tilePos"])
		if EN!=null:
			quit_pp(own,data["spell"])
			Globals.effectManager.sheet_fx("MAGIC",wPos)
			yield(get_tree().create_timer(.7), "timeout")
			EN.get_node("Sprite").set_scale(Vector2(.8,.8))
			EN.ATTRIBUTABLE.add_attr("atk",-2)
			Globals.effectManager.text_effect(wPos,"< Debilitado >")
			Globals.GUI.add_info_concat("Conjuro   < "+Globals.HabsManager.getHab(data["spell"])["name"]+" >   lanzado a   "+EN.visual_name+"   -2atk")
			Globals.GUI.add_info_line()
			Globals.turnController.finishTurn(own)
	
	if data["spell"]=="IMPACTO":
		var EN=check_enem(data["tilePos"])
		if EN!=null:
			quit_pp(own,data["spell"])
			Globals.effectManager.sheet_fx("MAGIC",wPos)
			yield(get_tree().create_timer(.7), "timeout")
			Globals.DDCORE.ataque_magico(90,POWER,EN)
			Globals.turnController.finishTurn(own)
	
	if data["spell"]=="EXPLOSION":
		quit_pp(own,data["spell"])
		Globals.effectManager.sheet_fx("MAGIC",wPos)
		for xx in range(-2,3):
			for yy in range(-2,3):
				var pos=data["tilePos"]+Vector2(xx,yy)
				var EN=Globals.TilemapManager.get_element(pos,"ENEMIES")
				if EN!=null: Globals.DDCORE.ataque_magico(90,POWER,EN)
				else: Globals.effectManager.sheet_fx("SLASH",Globals.to_wpos(pos) )
		yield(get_tree().create_timer(.7), "timeout")
		Globals.turnController.finishTurn(own)
	
	yield(get_tree().create_timer(.5), "timeout")
	own.setState("MOVE")

func check_enem(POS):
	var wPos=Globals.tile_map.map_to_world(POS)+Globals.tile_map.cell_size/2
	var enem=Globals.TilemapManager.get_element(POS,"ENEMIES")
	if enem==null: 
		Globals.effectManager.text_effect(wPos,"no hay objetivo")
		return null
	return enem

func check_pp(OWN,SPELL):
	if OWN.ATTRIBUTABLE.get_attr(".pp")<getHab(SPELL)["cost"]:
		Globals.effectManager.text_effect(OWN.position,"PP insuficiente")
		return false	
	return true

func quit_pp(OWN,SPELL):
	OWN.ATTRIBUTABLE.add_attr(".pp",-getHab(SPELL)["cost"])
	var CAN=OWN.ABILITYABLE.get_full_hab("CANALIZAR")
	if CAN>0 and Globals.rndi(1,100)<CAN*10:
		Globals.effectManager.custom_text_effect(OWN.position,"POWER","+1 PP")
		OWN.ATTRIBUTABLE.add_attr(".pp",1)
