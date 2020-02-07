extends Node2D

var chestObject = preload("res://Nodes/ItemsBag.tscn")

func getItem(CODE):
	var ITEM
	match CODE:
		#EQUIPABLES
		101: ITEM={"icon":0, "lvl":0, "name": "Espada", "type":"Hand", "attr":{"atk":2,"def":-1}}
		102: ITEM={"icon":1, "lvl":0, "name": "Espada Ancha", "type":"Hand", "attr":{"atk":1}}
		101: ITEM={"icon":0, "lvl":0, "name": "Espada Guerrera", "type":"Hand", "attr":{"atk":1}, "code_hab_1":"BERSERK", "cnt_hab_1":+2}
		103: ITEM={"icon":2, "lvl":0, "name": "Baculo Magico", "type":"Hand", "attr":{"pow":2}}
		104: ITEM={"icon":3, "lvl":0, "name": "Ballesta", "type":"Hand", "attr":{}, "code_hab_1":"ARQUERIA", "code_hab_2":"PUNTERIA","cnt_hab_2":+2}
		105: ITEM={"icon":4, "lvl":0, "name": "Yelmo", "type":"Head", "attr":{"def":2}} 
		106: ITEM={"icon":5, "lvl":0, "name": "Sombrero Magico","type":"Head", "attr":{"pp":2}} 
		#CONSUMIBLES
		201: ITEM={"icon":12, "lvl":0, "name": "Manzana", "type":"Use", "cnt":1, "desc": "+2hp"} 
		202: ITEM={"icon":13, "lvl":0, "name": "Carne", "type":"Use", "cnt":1, "desc": "+6hp"} 
		203: ITEM={"icon":14, "lvl":0, "name": "Pocion", "type":"Use", "cnt":1, "desc": "+4pp"} 
		204: ITEM={"icon":16, "lvl":0, "name": "Elixir Fuerza", "type":"Use", "cnt":1, "desc": "+5atk"} 
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
	var cnt=Globals.rndi(1,4)
	var NEXT_ITEM
	while (CH.items.size()<cnt):
		var r=Globals.rndi(0,100)
		if r<60: 
			NEXT_ITEM=getItem( Globals.rndi(101,105) )
		else : 
			NEXT_ITEM=getItem( Globals.rndi(201,203) )
			NEXT_ITEM["cnt"]=Globals.rndi(1,5)
			
		if NEXT_ITEM["lvl"]==0:
			CH.items.append(NEXT_ITEM)


func build_description(ITEM):
	if ITEM.get("desc"): return ITEM.get("desc")
	if !ITEM.get("attr"): return "---"
	var DESC=""
	for at in ITEM["attr"]: 
		if ITEM["attr"][at]>0: DESC+="+"
		DESC+=str(ITEM["attr"][at])+at+"  "
	return DESC