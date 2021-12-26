extends Node2D

onready var rnd=RandomNumberGenerator.new()
onready var DunGen=get_node("/root/Node2D/DungeonGenerator")
#tiles={ "LIBRE":5, "MURO":0, "SUELO":1,  "BLOQUEADO":0, "PASILLO":1, "INICIO":2, "SALIDA":3 , "PUERTA":4 }

func _ready():
	rnd.randomize()

func get_room_empty_rnd(min_tam=Vector2(4,4),max_tam=Vector2(6,6)):
	#r={ x y cx cy w h data:[][] objs:[] }
	var r={"objs":[]}
	r["w"]=rnd.randi_range(4, 6)
	r["h"]=rnd.randi_range(4, 6)
	r["data"]=[]
	for x in range(0,r["w"]):
			r["data"].append([])
			for y in range(0,r["h"]):
				r["data"][x].append( DunGen.tiles["SUELO"] )
	return r
	
func get_room_empty_2(): #NO SE USA, SOLO FUE UN TEST
	var r={"w":3, "h":3, "data":[], "objs":[]}
	var s=DunGen.tiles["SUELO2"]
	var MP=[]
	MP.append([s,s,s])
	MP.append([s,s,s])
	MP.append([s,s,s])
	r["data"]=MP
	r["objs"].append( { "type":"CHEST", "pos":Vector2(0,0) } )
	return r

func get_room_empty_3(): #NO SE USA, SOLO FUE UN TEST
	var r={"w":9, "h":6, "data":[], "objs":[]}
	var s=DunGen.tiles["SUELO"]
	var z=DunGen.tiles["SUELO2"]
	var x=DunGen.tiles["MURO"]
	var p=DunGen.tiles["PUERTA"]
	var MP=[]
	MP.append([s,s,s,s,s,s,s,s,s])
	MP.append([s,x,x,x,x,x,x,x,s])
	MP.append([s,x,s,s,s,s,s,x,s])
	MP.append([s,x,s,s,s,s,s,x,s])
	MP.append([s,x,x,x,p,x,x,x,s])
	MP.append([s,s,s,s,s,s,s,s,s])
	r["data"]=reorientation_room(MP)
	r["objs"].append( { "type":"CHEST", "pos":Vector2(4,2) } )
	r["objs"].append( { "type":"ENEMY", "pos":Vector2(4,3) } )
	return r

func create_room_objects(r):
	#r={ x y cx cy w h data:[][] objs:[] }
	for obj in r["objs"]:
		var p=obj["pos"]+Vector2(r["x"],r["y"])
		var CAS=DunGen.DATAMAP[p.x][p.y]
#		print(str(CAS)+":: "+obj["type"])
		if CAS==DunGen.tiles["INICIO"]: continue
		if CAS==DunGen.tiles["SALIDA"]: continue
#		print("^creado^") 
		
		if (obj["type"]=="CHEST"): Globals.ItemsManager.createChest(p)
		if (obj["type"]=="ENEMY"): Globals.EnemiesManager.random_enemy(DunGen.NIVEL+1,p)
		if (obj["type"]=="CARTEL"): Globals.ItemsManager.createCartel(p,obj["text"])
		if (obj["type"]=="FUENTE"): Globals.ItemsManager.createFuente(p)
		if (obj["type"]=="ALTAR"): Globals.ItemsManager.createAltar(p)

func reorientation_room(MP):
	var h=MP.size()
	var w=MP[0].size()
	var MP2=[]
	for x in range(0,w):
		var line=[]
		for y in range(0,h):
			line.append( MP[y][x] )
		MP2.append(line)
	return MP2

func generate_tutorial_dungeon():
	#r={ x y cx cy w h data:[][] objs:[] }
	var r={"x":1, "y":1, "w":0, "h":0, "data":[], "objs":[]}
	var s=DunGen.tiles["SUELO"]
	var z=DunGen.tiles["SUELO2"]
	var x=DunGen.tiles["MURO"]
	var p=DunGen.tiles["PUERTA"]
	var f=DunGen.tiles["SALIDA"]
	DunGen.POS_INI=Vector2(1,1)+Vector2(1,1)
	var MP=[]
	MP.append([x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x]) #0
	MP.append([x,s,s,s,s,s,s,s,p,s,s,s,s,x,s,p,s,s,s,x]) #1
	MP.append([x,x,x,x,x,x,x,x,x,s,s,s,s,x,s,x,x,x,s,x]) #2
	MP.append([x,s,x,s,s,s,x,x,x,s,s,s,s,s,s,x,x,x,s,x]) #3
	MP.append([x,f,x,s,s,s,x,x,x,x,x,x,x,x,x,x,x,x,p,x]) #4
	MP.append([x,s,x,s,s,s,s,s,s,s,s,p,s,s,x,s,s,s,s,x]) #5
	MP.append([x,s,x,s,s,s,x,x,x,x,x,x,s,s,x,s,s,s,s,x]) #6
	MP.append([x,s,s,s,s,s,x,s,s,s,s,x,s,s,p,s,s,s,s,x]) #7
	MP.append([x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x]) #8
	#          0         5         0         5                
	r["w"]=MP[0].size()
	r["h"]=MP.size()
	DunGen.map_w=r["w"]+2
	DunGen.map_h=r["h"]+2
	DunGen.DATAMAP = DunGen.create_map(DunGen.map_w,DunGen.map_h,DunGen.tiles["BLOQUEADO"])
	r["data"]=reorientation_room(MP)
	
	r["objs"].append( { "type":"CARTEL", "pos":Vector2(2,1), "text":Globals.DialogsManager.PREDIAG["T1"] } )
	r["objs"].append( { "type":"CARTEL", "pos":Vector2(7,1), "text":Globals.DialogsManager.PREDIAG["T2"] } )
	r["objs"].append( { "type":"CARTEL", "pos":Vector2(9,1), "text":Globals.DialogsManager.PREDIAG["T3"] } )
	r["objs"].append( { "type":"CHEST", "pos":Vector2(14,3) } )
	r["objs"].append( { "type":"CARTEL", "pos":Vector2(14,2), "text":Globals.DialogsManager.PREDIAG["T4"] } )
	r["objs"].append( { "type":"CARTEL", "pos":Vector2(18,3), "text":Globals.DialogsManager.PREDIAG["T5"] } )
	r["objs"].append( { "type":"ENEMY", "pos":Vector2(17,6) } )
	r["objs"].append( { "type":"CHEST", "pos":Vector2(15,5) } )
	r["objs"].append( { "type":"CARTEL", "pos":Vector2(13,7), "text":Globals.DialogsManager.PREDIAG["T6"] } )
	r["objs"].append( { "type":"FUENTE", "pos":Vector2(13,5) } )
	r["objs"].append( { "type":"CARTEL", "pos":Vector2(5,5), "text":Globals.DialogsManager.PREDIAG["T7"] } )
	r["objs"].append( { "type":"ALTAR", "pos":Vector2(3,5) } )
	r["objs"].append( { "type":"CARTEL", "pos":Vector2(1,5), "text":Globals.DialogsManager.PREDIAG["T8"] } )
	DunGen.addRoomToMap(r)
	for RM in DunGen.ROOMS: create_room_objects(RM)
