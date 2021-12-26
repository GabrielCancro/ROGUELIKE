extends Node2D

var DATA_ORIGINAL={"volumen":-20,"score":0,"encurso":true}
var DATA_SAVE=DATA_ORIGINAL
var file_url="user://rogueData.save"
var file_player="user://playerData.save"

func save_options():
	var F = File.new()
	F.open(file_url, File.WRITE)
	F.store_line(JSON.print(DATA_SAVE))
	F.close()

func load_options():
	var F = File.new()
	if F.file_exists(file_url):
		F.open(file_url, File.READ)
		var NEW_DATA=JSON.parse(F.get_line()).result
		F.close()
		for DT in DATA_SAVE:
			if !NEW_DATA.has(DT):
				NEW_DATA[DT]=DATA_SAVE[DT]
		DATA_SAVE=NEW_DATA
	set_loads()

func set_loads():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), DATA_SAVE["volumen"])

func reset_options():
	var dir = Directory.new()
	dir.remove(file_url)
	load_options()

func save_player_data():
	var F = File.new()
	F.open(file_player, File.WRITE)
	var PLAYER_DATA={}
	PLAYER_DATA["equip"]=Globals.player.INVENTARIABLE.equip
	PLAYER_DATA["items"]=Globals.player.INVENTARIABLE.items
	PLAYER_DATA["baseHabs"]=Globals.player.ABILITYABLE.baseHabs
	PLAYER_DATA["objectHabs"]=Globals.player.ABILITYABLE.objectHabs
	PLAYER_DATA["baseAttr"]=Globals.player.ATTRIBUTABLE.baseAttr
	PLAYER_DATA["objectAttr"]=Globals.player.ATTRIBUTABLE.objectAttr
	PLAYER_DATA["states"]=Globals.player.STATEABLE.states
	PLAYER_DATA["SCORE"]=DATA_SAVE["score"]
	PLAYER_DATA["DUNGEON_LEVEL"]=Globals.dunGen.NIVEL
	#NIVEL+ATRIBUTOS+HABILIDADES+ITEMS+EQUIPAMIENTOS
	F.store_line(JSON.print(PLAYER_DATA))
	F.close()

func load_player_data():
	var F = File.new()
	if !F.file_exists(file_player): return
	F.open(file_player, File.READ)
	var PLAYER_DATA=JSON.parse(F.get_line()).result
	F.close()
	Globals.player.INVENTARIABLE.equip=PLAYER_DATA["equip"]
	Globals.player.INVENTARIABLE.items=PLAYER_DATA["items"]
	Globals.player.ABILITYABLE.baseHabs=PLAYER_DATA["baseHabs"]
	Globals.player.ABILITYABLE.objectHabs=PLAYER_DATA["objectHabs"]
	Globals.player.ATTRIBUTABLE.baseAttr=PLAYER_DATA["baseAttr"]
	Globals.player.ATTRIBUTABLE.objectAttr=PLAYER_DATA["objectAttr"]
	Globals.player.STATEABLE.states=PLAYER_DATA["states"]
	DATA_SAVE["score"]=PLAYER_DATA["SCORE"]
	Globals.dunGen.NIVEL=PLAYER_DATA["DUNGEON_LEVEL"]-1