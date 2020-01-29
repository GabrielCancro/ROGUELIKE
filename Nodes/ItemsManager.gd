extends Node2D

var chestObject = preload("res://Nodes/ItemsBag.tscn")

func getItem(CODE):
	var ITEM
	match CODE:
		#EQUIPABLES
		101: ITEM={"icon":0, "name": "Espada", "type":"Hand", "attr":{"atk":2,"def":-1}}
		102: ITEM={"icon":1, "name": "Espada Ancha", "type":"Hand", "attr":{"atk":1}}
		101: ITEM={"icon":0, "name": "Espada Guerrera", "type":"Hand", "attr":{"atk":1}, "code_hab_1":"BERSERK", "cnt_hab_1":+2}
		103: ITEM={"icon":2, "name": "Baculo Magico", "type":"Hand", "attr":{"pow":2}}
		104: ITEM={"icon":3, "name": "Ballesta", "type":"Hand", "attr":{}, "code_hab_1":"ARQUERIA", "code_hab_2":"PUNTERIA","cnt_hab_2":+2}
		105: ITEM={"icon":4, "name": "Yelmo", "type":"Head", "attr":{"def":2}} 
		106: ITEM={"icon":5, "name": "Sombrero Magico","type":"Head", "attr":{"pp":2}} 
		#CONSUMIBLES
		201: ITEM={"icon":12, "name": "Manzana", "type":"Use", "cnt":1, "desc": "+2hp"} 
		202: ITEM={"icon":13, "name": "Carne", "type":"Use", "cnt":1, "desc": "+6hp"} 
		203: ITEM={"icon":14, "name": "Pocion", "type":"Use", "cnt":1, "desc": "+4pp"} 
		204: ITEM={"icon":16, "name": "Elixir Fuerza", "type":"Use", "cnt":1, "desc": "+5atk"} 
	ITEM["code"]=CODE
	return ITEM

func use_consumible(own,CODE):
	if CODE==201: own.ATTRIBUTABLE.add_attr(".hp",2)
	elif CODE==202: own.ATTRIBUTABLE.add_attr(".hp",6)
	elif CODE==203: own.ATTRIBUTABLE.add_attr(".pp",4)

func createChest(pos):
	var CH=chestObject.instance()
	add_child(CH)
	CH.TILEABLE.set_tile_pos(pos)
	
	for i in range(10):
		var r=Globals.rndi(0,100)
		if r<85: continue
		elif r<95: CH.items.append( getItem( Globals.rndi(101,105) ) )
		elif r<100: 
			var ITM=getItem( Globals.rndi(201,203) )
			ITM["cnt"]=Globals.rndi(1,5)
			CH.items.append(ITM)

func build_description(ITEM):
	if ITEM.get("desc"): return ITEM.get("desc")
	if !ITEM.get("attr"): return "---"
	var DESC=""
	for at in ITEM["attr"]: 
		if ITEM["attr"][at]>0: DESC+="+"
		DESC+=str(ITEM["attr"][at])+at+"  "
	return DESC