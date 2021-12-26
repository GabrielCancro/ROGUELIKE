extends Node2D

var objectMap = preload("res://Game/objectMap.tscn")
var all_items={}
var items_by_level={}

func _ready():
	randomize()
	load_items_file()
#	get_items_by_level(0)

#JSON FILE ITEMS LOAD!
func load_items_file():
	var file = File.new()
	file.open("res://JSON/items.json", File.READ)
	var json = file.get_as_text()
	file.close()
	var json_result = JSON.parse(json).result
	for IT in json_result:
		if IT!="//": add_item(int(IT),json_result[IT])

func add_item(CODE,myItem):
	myItem["code"]=CODE
	if all_items.get(CODE,null)!=null: print("CODIGO DE ARMA REPETIDO!! "+str(CODE))
	all_items[CODE]=myItem
	for L in range(myItem["min_dun"],myItem["max_dun"]+1):
		L=int(L)
		if !items_by_level.has(L): items_by_level[L]=[]
		items_by_level[L].append(myItem)
#		print(str(L)+myItem["name"]+" icon "+str(+myItem["icon"]))

func getItem(CODE):
	return all_items[CODE].duplicate()

func get_items_by_level(level):
	return items_by_level[level]

func get_rnd_items_by_level(level):
	var item_level_list=items_by_level[level]
	return item_level_list[ randi()%item_level_list.size() ]

func use_consumible(own,CODE):
	var attr={}
	attr[".hp"]=2
	if CODE==201: attr[".hp"]=2
	elif CODE==202: attr[".hp"]=3
	elif CODE==203: attr[".pp"]=3
	elif CODE==204: attr[".hp"]=2
	elif CODE==205: attr[".pp"]=1
	elif CODE==206: 
		attr["hp"]=1
		attr[".hp"]=1
	Globals.SoundsManager.play_sfx("Eat")
	Globals.turnController.finishTurn(own)
	
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

func createCartel(pos,text):
	var CH=objectMap.instance()
	add_child(CH)
	CH.set_type("CARTEL")
	CH.TILEABLE.set_tile_pos(pos)
	CH.data["text"]=text
	CH.data["isOnly"]=true

func items_to_new_level(level: int)->Array:
	#Los items que se daran en el nuevo nivel estaran entre el rango de 2 niveles menos y un nivel mas del actual
	var array:=[]
	var cntItems
	if level<4: cntItems=randi()%2+1
	else: cntItems=randi()%2+1
	
#	var min_lvl=max(1,min(6,level-floor(level/3)))
#	var max_lvl=max(1,min(6,level-ceil(level/2)))
#	print("new chest lvl "+str(level) )
	while(cntItems>=1):
#		var itemsList
#		var lvl=int( min_lvl+randi()%int(max(1,max_lvl-min_lvl)) )
		var newItem=get_rnd_items_by_level(level)
		array.append( newItem )
		cntItems-=1
#		newItemLevel=randi()%101+1  #Da un numero de 1 a 100 (para trabajar como si fueran porsentajes)
		# si estamos en el nivel 0 o 1 las posibilidades de que toque un item del mismo nivel aumentan
		# esta configurado para que si estamos en el nivel 6 no intenta tomar items del nivel 7 y tamoco un nivel menor a 0
#		if(newItemLevel<=40): #Probabilidad de que toque nivel 0 es 40%
#			itemsList=get_items_by_level(rand_range(min_lvl,max_lvl))
#		elif (newItemLevel<=50): #Probabilidad de que toque nivel -2 es 10%
#			itemsList=get_items_by_level(max(1,level-2))
#		elif(newItemLevel<=65): #Probabilidad de que toque nivel -1 es 15%
#			itemsList=get_items_by_level(max(1,level-1))
#		elif (newItemLevel<=90): #Probabilidad dd que toque nivel actual es de 25%
#			itemsList=get_items_by_level(level)
#		else: #Probabilidad de que toque nivel +1 es 10%
#			itemsList=get_items_by_level(min(level+1,6))
#		#Ahora se agrega el nuevo item, el numero del item esta entre 0 y el ItemList.size()-1
	return array

func build_description(ITEM):
	if ITEM.get("desc"): return ITEM.get("desc")
	if !ITEM.get("attr"): return "---"
	var DESC=""
	for at in ITEM["attr"]: 
		if ITEM["attr"][at]>0: DESC+="+"
		DESC+=str(ITEM["attr"][at])+at+"  "
	return DESC
