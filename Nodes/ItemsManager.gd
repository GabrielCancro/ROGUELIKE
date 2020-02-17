extends Node2D

var objectMap = preload("res://Nodes/objectMap.tscn")
var all_items={}
var items_by_level={}

func _ready():
	randomize()
	#CREAMOS TODOS LOS ITEMS DEL JUEGO
	add_item(101,{"icon":1, "lvl":1, "name": "Garrote", "type":"Hand", "attr":{"atk":1,"def":-1}} )
	add_item(102,{"icon":2, "lvl":2, "name": "Cuchilla Vieja", "type":"Hand", "attr":{"atk":1}} )
	add_item(103,{"icon":2, "lvl":3, "name": "Daga", "type":"Hand", "attr":{"atk":1}} )
	add_item(104,{"icon":3, "lvl":4, "name": "Espada Corta", "type":"Hand", "attr":{"atk":2}} )
	add_item(105,{"icon":4, "lvl":5, "name": "Espadon", "type":"Hand", "attr":{"atk":3,"def":-1}}  )
	add_item(106,{"icon":5, "lvl":6, "name": "Maza Pinchuda", "type":"Hand", "attr":{"atk":4,"def":-2}}  )
	
	add_item(121,{"icon":233, "lvl":3, "name": "Ballesta", "type":"Hand", "attr":{},
	         "code_hab_1":"ARQUERIA","code_hab_2":"PUNTERIA", "cnt_hab_2":1} )
	add_item(122,{"icon":26, "lvl":3, "name": "Baculo Magico", "type":"Hand", "attr":{"atk":1},
	         "code_hab_1":"IMPACTO", "cnt_hab_1":1} )
	add_item(123,{"icon":13, "lvl":5, "name": "Cetro", "type":"Hand", "attr":{"atk":1,"pp":2},
	         "code_hab_1":"IMPACTO", "cnt_hab_1":2} )
	
	add_item(131,{"icon":7, "lvl":2, "name": "Casquete", "type":"Head", "attr":{"def":1}} )
	add_item(132,{"icon":28, "lvl":4, "name": "Casco", "type":"Head", "attr":{"def":2, "pp":-1}} )
	add_item(133,{"icon":29, "lvl":5, "name": "Yelmo", "type":"Head", "attr":{"def":2,"see":-1}} )
	add_item(134,{"icon":15, "lvl":4, "name": "Sombrero", "type":"Head", "attr":{"pp":2}} )
	
	add_item(151,{"icon":9, "lvl":5, "name": "Armadura", "type":"Body", "attr":{"def":3,"pp":-2,"stp":-1}} )
	add_item(152,{"icon":16, "lvl":4, "name": "Capa Magica", "type":"Body", "attr":{"def":1, "pp":2}} )
	
	add_item(171,{"icon":11, "lvl":3, "name": "Escudo", "type":"Scnd", "attr":{"def":2,"atk":-1}} )
	
	add_item(201,{"icon":19, "lvl":0, "name": "Manzana", "type":"Use", "cnt":1, "desc": "+2hp"} )
	add_item(202,{"icon":20, "lvl":0, "name": "Carne", "type":"Use", "cnt":1, "desc": "+4hp"} )
	add_item(203,{"icon":17, "lvl":0, "name": "Pocion de Poder", "type":"Use", "cnt":1, "desc": "+3pp"} )
	add_item(204,{"icon":25, "lvl":0, "name": "Hierbas Curativas", "type":"Use", "cnt":1, "desc": "+2hp"} )
	
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
	return items_by_level[level]

func use_consumible(own,CODE):
	var attr={}
	attr[".hp"]=2
	if CODE==201: attr[".hp"]=2
	elif CODE==202: attr[".hp"]=4
	elif CODE==203: attr[".pp"]=3
	elif CODE==204: attr[".hp"]=2
	
	for AT in attr:
		own.ATTRIBUTABLE.add_attr(AT,attr[AT])
		if AT==".hp": Globals.effectManager.custom_text_effect(own.position,"LIFE","+"+str(attr[AT])+" HP")
		elif AT==".pp": Globals.effectManager.custom_text_effect(own.position,"POWER","+"+str(attr[AT])+" PP") 
	
func createChest(pos):
	var CH=objectMap.instance()
	add_child(CH)
	CH.set_type("CHEST")
	CH.TILEABLE.set_tile_pos(pos)
	CH.items=items_to_new_level(Globals.dunGen.NIVEL)

func createAltar(pos):
	var AL=objectMap.instance()
	add_child(AL)
	AL.set_type("ALTAR")
	AL.TILEABLE.set_tile_pos(pos)

func createFuente(pos):
	var FN=objectMap.instance()
	add_child(FN)
	FN.set_type("FUENTE")
	FN.TILEABLE.set_tile_pos(pos)

func items_to_new_level(level: int)->Array:
	#Los items que se daran en el nuevo nivel estaran entre el rango de 2 niveles menos y un nivel mas del actual
	var array:=[]
	var itemsList
	var numItems:=randi()%3+1 #Da un numero aleatoria entre 1 y 3
	if level<=3: numItems=min(numItems,2)
	var newItemLevel
	while(numItems>=1):
		newItemLevel=randi()%101+1  #Da un numero de 1 a 100 (para trabajar como si fueran porsentajes)
		# si estamos en el nivel 0 o 1 las posibilidades de que toque un item del mismo nivel aumentan
		# esta configurado para que si estamos en el nivel 6 no intenta tomar items del nivel 7 y tamoco un nivel menor a 0
		if(newItemLevel<=40): #Probabilidad de que toque nivel 0 es 40%
			itemsList=get_items_by_level(0)
		elif (newItemLevel<=50): #Probabilidad de que toque nivel -2 es 10%
			itemsList=get_items_by_level(max(level-2,0))
		elif(newItemLevel<=65): #Probabilidad de que toque nivel -1 es 15%
			itemsList=get_items_by_level(max(level-1,1))
		elif (newItemLevel<=90): #Probabilidad dd que toque nivel actual es de 25%
			itemsList=get_items_by_level(level)
		else: #Probabilidad de que toque nivel +1 es 10%
			itemsList=get_items_by_level(min(level+1,6))
		#Ahora se agrega el nuevo item, el numero del item esta entre 0 y el ItemList.size()-1
		array.append(itemsList[randi()%itemsList.size()])
		numItems-=1
	return array

func build_description(ITEM):
	if ITEM.get("desc"): return ITEM.get("desc")
	if !ITEM.get("attr"): return "---"
	var DESC=""
	for at in ITEM["attr"]: 
		if ITEM["attr"][at]>0: DESC+="+"
		DESC+=str(ITEM["attr"][at])+at+"  "
	return DESC