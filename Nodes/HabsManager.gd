extends Node2D

func getHab(CODE):
	var HAB
	match CODE:
		#HABILIDADES PAS/ACT
		"BERSERK": HAB={"icon":0, "name": "Berserker", "type":"PAS",
		                "desc": "Obtienes +[atk] pero -[def]"}
		"PUNTERIA": HAB={"icon":0, "name": "Punteria", "type":"PAS",
		                "desc": "Mejora el [atk] con proyectiles"}
		"ARQUERIA": HAB={"icon":0, "name": "Arqueria", "type":"ACT",
		                "desc": "Permite disparar proyectiles"}
		"DEBILITAR": HAB={"icon":0, "name": "Debilitar", "type":"ACT",
		                "desc": "Reduce el [atk] del objetivo (-1pp)"}
		
	HAB["code"]=CODE
	HAB["cost"]=HAB.get("cost",0)
	HAB["cnt"]=HAB.get("cnt",0)
	return HAB

func ejecutarHab(own,data):
	#Globals.effectManager.text_effect(own.position,data["hab"]+" "+str(data["cnt"]))
	if data["hab"]=="ARQUERIA":
		own.showSelectorTilePos(data)
	elif data["hab"]=="DEBILITAR":
		own.showSelectorTilePos(data)

func ejecutarHabInPos(own,data):
	print("ejecutarHabInPos: "+str(data))
	var wPos=Globals.tile_map.map_to_world(data["tilePos"])+Globals.tile_map.cell_size/2
	if data["hab"]=="ARQUERIA":
		Globals.effectManager.text_effect(wPos,data["hab"]+" "+str(data["cnt"]))
	elif data["hab"]=="DEBILITAR":
		if own.ATTRIBUTABLE.get_attr(".pp")>=1:			
			var enem=Globals.TilemapManager.get_element(data["tilePos"],"ENEMIES")
			if enem!=null: 
				own.ATTRIBUTABLE.add_attr(".pp",-1)
				Globals.effectManager.magic_effect(wPos)
				yield(get_tree().create_timer(1), "timeout")
				enem.get_node("Sprite").set_scale(Vector2(1.5,1.5))
				print(str(enem.ATTRIBUTABLE.baseAttr))
				enem.ATTRIBUTABLE.add_attr("atk",-2)
				print(str(enem.ATTRIBUTABLE.baseAttr))
				Globals.effectManager.text_effect(wPos,"< Debilitado >")
				Globals.turnController.finishTurn(own)
				
			else: Globals.effectManager.text_effect(wPos,"no hay objetivo")
		else: Globals.effectManager.text_effect(wPos,"PP insuficiente")
		
		
	yield(get_tree().create_timer(.5), "timeout")
	own.setState("MOVE")