extends Node2D

var chestObject = preload("res://Nodes/ItemsBag.tscn")
var all_items={}
var items_by_level={}

func _ready():
	#CREAMOS TODOS LOS ITEMS DEL JUEGO
	add_item(101,{"icon":1, "lvl":1, "name": "Garrote", "type":"Hand", "attr":{"atk":1,"def":-1}} )
	add_item(102,{"icon":2, "lvl":2, "name": "Cuchilla Vieja", "type":"Hand", "attr":{"atk":1}} )
	add_item(103,{"icon":2, "lvl":3, "name": "Daga", "type":"Hand", "attr":{"atk":1}} )
	add_item(104,{"icon":3, "lvl":4, "name": "Espada Corta", "type":"Hand", "attr":{"atk":2}} )
	add_item(105,{"icon":4, "lvl":5, "name": "Espadon", "type":"Hand", "attr":{"atk":3,"def":-2}}  )
	add_item(106,{"icon":5, "lvl":6, "name": "Maza Pinchuda", "type":"Hand", "attr":{"atk":4,"def":-3}}  )
	
	add_item(121,{"icon":13, "lvl":1, "name": "Baculo Magico", "type":"Hand", "attr":{"atk":1}, "code_hab_1":"DEBILITAR"} )
	add_item(122,{"icon":13, "lvl":3, "name": "Cetro", "type":"Hand", "attr":{"atk":1,"pp":2}, "code_hab_1":"DEBILITAR"} )
	
	add_item(131,{"icon":7, "lvl":2, "name": "Yelmo", "type":"Head", "attr":{"def":1}} )
	
	add_item(151,{"icon":9, "lvl":3, "name": "Armadura", "type":"Body", "attr":{"def":3,"atk":-1,"pp":-1}} )
	add_item(152,{"icon":16, "lvl":3, "name": "Capa Magica", "type":"Body", "attr":{"def":1, "pp":2}} )
	
	add_item(171,{"icon":11, "lvl":2, "name": "Escudo", "type":"Scnd", "attr":{"def":1,"atk":-1}} )
	
	add_item(201,{"icon":19, "lvl":0, "name": "Manzana", "type":"Use", "cnt":1, "desc": "+2hp"} )
	add_item(202,{"icon":20, "lvl":0, "name": "Carne", "type":"Use", "cnt":1, "desc": "+4hp"} )
	add_item(203,{"icon":17, "lvl":0, "name": "Pocion", "type":"Use", "cnt":1, "desc": "+3pp"} )
	
	#"code_hab_1":"BERSERK", "cnt_hab_1":+2}
	get_items_by_level(0)

func add_item(CODE,myItem):
	myItem["code"]=CODE
	all_items[CODE]=myItem
	if !items_by_level.has(myItem["lvl"]): 
		items_by_level[myItem["lvl"]]=[]
	items_by_level[myItem["lvl"]].append(myItem)

func getItem(CODE):
	return all_items[CODE].duplicate()

func get_items_by_level(level):
	#print(str(items_by_level))
	return items_by_level[level]

func use_consumible(own,CODE):
	if CODE==201: own.ATTRIBUTABLE.add_attr(".hp",2)
	elif CODE==202: own.ATTRIBUTABLE.add_attr(".hp",4)
	elif CODE==203: own.ATTRIBUTABLE.add_attr(".pp",3)

func createChest(pos):
	var CH=chestObject.instance()
	add_child(CH)
	CH.TILEABLE.set_tile_pos(pos)
	var cnt=Globals.rndi(0,3)
	var NEXT_ITEM
	while (CH.items.size()<cnt):
		if Globals.rndi(0,100)<50:
			NEXT_ITEM=getItem(Globals.rndi(201,203))
			NEXT_ITEM["cnt"]=Globals.rndi(1,2)
		else:
			var items_in_level=get_items_by_level(Globals.dunGen.NIVEL)
			NEXT_ITEM=items_in_level[ Globals.rndi(0,items_in_level.size()-1) ]
		CH.items.append(NEXT_ITEM)

func build_description(ITEM):
	if ITEM.get("desc"): return ITEM.get("desc")
	if !ITEM.get("attr"): return "---"
	var DESC=""
	for at in ITEM["attr"]: 
		if ITEM["attr"][at]>0: DESC+="+"
		DESC+=str(ITEM["attr"][at])+at+"  "
	return DESC