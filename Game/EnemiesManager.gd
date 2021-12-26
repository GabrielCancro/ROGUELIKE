extends Node2D

var enemyObject = preload("res://Game/Enemy.tscn")
var enemies_list={}
var enemies_spriter_list={}
var enemies_by_level={}

func _ready():
	load_enemies_file()
	
func load_enemies_file():
	var file = File.new()
	file.open("res://JSON/enemies.json", File.READ)
	var json = file.get_as_text()
	file.close()
	var json_result = JSON.parse(json).result
	for IT in json_result:
		if IT!="//": add_enemy_to_list(IT,json_result[IT])

func add_enemy_to_list(CODE,myEnem):
	myEnem["code"]=CODE
	if enemies_list.get(CODE,null)!=null: print("CODIGO DE ENEMIGO REPETIDO!! "+str(CODE))
	enemies_list[CODE]=myEnem
	enemies_spriter_list[CODE]=load("res://sprites/enemies/"+myEnem["sprite"]+".png")
	for L in range(myEnem["min_dun"],myEnem["max_dun"]+1):
		L=int(L)
		if !enemies_by_level.has(L): enemies_by_level[L]=[]
		enemies_by_level[L].append(myEnem)
#		print(str(L)+myEnem["name"])

func get_rnd_enemy_by_level(level):
	var list=enemies_by_level[level]
	return list[randi()%list.size()]

#CREA UN ENEMIGO RANDOM DE CIERTO NIVEL
func random_enemy(level: int, pos)->void:
	create_enemy(get_rnd_enemy_by_level(level)["code"],pos)

#USAR PARA CREAR ENEMIGOS
func create_enemy(CODE,pos):
	if Globals.TilemapManager.get_element(pos,"ENEMIES"): return false
	var enemData=enemies_list[CODE]
	var EN=enemyObject.instance()
	add_child(EN)
	EN.visual_name=enemData["name"]
	EN.get_node("Sprite").set_texture(enemies_spriter_list[CODE])
	enemData["attr"][".hp"]=enemData["attr"]["hp"]
	enemData["attr"]["pp"]=enemData["attr"].get("pp",0)
	enemData["attr"][".pp"]=enemData["attr"]["pp"]
	EN.ATTRIBUTABLE.set_attr_dic( enemData["attr"] )
	if enemData.has("habs"):
		for H in enemData["habs"]:
			EN.ABILITYABLE.set_base_hab(H,enemData["habs"][H])
	
	EN.TILEABLE.set_tile_pos(pos)
