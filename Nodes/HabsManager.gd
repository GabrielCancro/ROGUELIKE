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
		
	HAB["code"]=CODE
	HAB["cost"]=HAB.get("cost",0)
	HAB["cnt"]=HAB.get("cnt",0)
	return HAB

func ejecutarHab(own,data):
	Globals.effectManager.text_effect(own.position,data["hab"]+" "+str(data["cnt"]))