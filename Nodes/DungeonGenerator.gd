extends Node2D

#      crplay.itch.io
#      gabrielcancro@gmail.com

#onready var ASTAR = preload('res://Nodes/UTILS/ASTAR.gd').new()
var NIVEL=0

var DATAMAP #es un array 2D con los tiles del mapa
var map_w #ancho del mapa a generar
var map_h #alto del mapa a generar

#indices de los tiles, por si los necesitas cambiar o algo
#							0							11							12
var tiles={ "LIBRE":10, "MURO":0, "SUELO":3,  "BLOQUEADO":13, "PASILLO":3, "INICIO":15, "SALIDA":14 , "PUERTA":8 , "PUERTA_OPEN":3 }
var traversablesIndexs=[10,3,14,15]
var ROOMS=[] #lista de habitaciones en el mapa
var min_room=Vector2(4,4)	#tamaño minimo de habitaciones
var max_room=Vector2(8,8)	#tamaño maximo de habitaciones
var cant_rooms

#poner en false para obtener el resultado del proceso rapidamente
#en true ira generando poco a poco para poder visualizar el proceso
var showProcess=false

var rnd = RandomNumberGenerator.new()   
var tile_map:TileMap

func _ready():
	rnd.randomize()

func generateDungeon(tile_map_target):
	NIVEL+=1
	map_w=25+NIVEL*6
	map_h=25+NIVEL*5
	cant_rooms=map_w*map_h/150
	print("ROOMS TOTALES "+str(cant_rooms))
	tile_map=tile_map_target
	DATAMAP = create_map(map_w,map_h,tiles["LIBRE"])
	if showProcess: draw_map(DATAMAP)
	
	for i in range(cant_rooms):
		create_room(min_room.x,max_room.x,min_room.y,max_room.y)		
		if showProcess: draw_map(DATAMAP)
		if showProcess: yield(get_tree().create_timer(0.05), "timeout")
	
	conectRooms()
	if showProcess: draw_map(DATAMAP)
	if showProcess: yield(get_tree().create_timer(0.5), "timeout")
	
	DATAMAP[ ROOMS[ROOMS.size()-1]["cx"] ][ ROOMS[ROOMS.size()-1]["cy"] ]=tiles["SALIDA"]
	DATAMAP[ ROOMS[0]["cx"] ][ ROOMS[0]["cy"] ]=tiles["INICIO"]
	
	finishMap(DATAMAP)
	addDoors()
	draw_map(DATAMAP)
	tile_map.update_bitmask_region()
	
	if showProcess: yield(get_tree().create_timer(0.5), "timeout")
	iniFog()
	#Globals.ASTAR.setAstar(Globals.dunGen.DATAMAP,[10,3])
	
	Globals.TilemapManager.remove_all_elements()
	addAltar()
	addFuente()
	addEnemies()
	addChests()
	
	var posRoomZero=Vector2(ROOMS[0]["cx"],ROOMS[0]["cy"])
	return posRoomZero

func create_map(w, h, baseTile):
	var m = []
	for x in range(w):
		var col = []
		for y in range(h):
			col.append(baseTile)
		m.append(col)
	return m

func create_room(min_w,max_w,min_h,max_h):
	var r={}
	r["w"]=rnd.randi_range(min_w, max_w)
	r["h"]=rnd.randi_range(min_h, max_h)
	#la habitacion no debe tocar los bordes del mapa
	for i in range(50):
		r["x"]=rnd.randi_range(2, map_w-3-r["w"])
		r["y"]=rnd.randi_range(2, map_h-3-r["h"])
		r["cx"]=floor(r["x"]+r["w"]/2)
		r["cy"]=floor(r["y"]+r["h"]/2)
		#si logramos ubicar la habitacion sin que se sobreponga a otra, la agregamos al mapa
		if roomIsSiteable(r):
			addRoomToMap(r)
			break;

func addRoomToMap(r):
	for x in range(r["x"],r["x"]+r["w"]):
			for y in range(r["y"],r["y"]+r["h"]):
				DATAMAP[x][y]=tiles["SUELO"]
	ROOMS.append(r)

func draw_map(map):
	#renderiza el DATAMAP al TileSet que se vera
	for x in map.size():		
		for y in map[0].size():			
			tile_map.set_cell(x,y,map[x][y])

func roomIsSiteable(r):
	#retorna true si la habitacion no se superpone con ninguna otra
	if ROOMS.size()<=0: return true
	for ri in ROOMS:
		if isRoomsOverlap(r,ri): return false
	return true

func isRoomsOverlap(room1, room2):
	#retorna true si las habitacion no se superponen entre si
	var l1=Vector2(room1["x"],room1["y"])
	var r1=l1+Vector2(room1["w"],room1["h"])
	var l2=Vector2(room2["x"],room2["y"])
	var r2=l2+Vector2(room2["w"],room2["h"])
	if(l1.x > r2.x or l2.x > r1.x): return false
	elif(l1.y > r2.y or l2.y > r1.y): return false
	else: return true

func crearPasillo(room1,room2):
	#conencta las habitaciones de forma sencilla con caminos rectos
	#en esta parte es habitual utilizar pathfinder,
	#en este caso no lo use para hacerlo mas sencillo
	var rc1=Vector2(room1["cx"],room1["cy"])
	var rc2=Vector2(room2["cx"],room2["cy"])
	var path=getRectangularPath(rc1,rc2)
	for pos in path:
		if DATAMAP[pos.x][pos.y]==tiles["LIBRE"]:
			DATAMAP[pos.x][pos.y]=tiles["PASILLO"]

func getRectangularPath(start,end):
	#esta funcion remplazaria al get_path de cualquier pathfinder
	var path=[]
	var pos=start
	var dir=Vector2(1,1)
	if pos.x>end.x: dir.x=-1
	if pos.y>end.y: dir.y=-1
	while pos!=end:		
		if pos.x!=end.x: pos.x+=dir.x
		elif pos.y!=end.y: pos.y+=dir.y
		path.append(pos)
	return path

func conectRooms():
	#conecta las habitaciones con pasillos del siguiente modo:
	#crea una lista vacia de habitaciones ya visitadas
	#y otra lista de habitaciones no visitadas, a esta incorpora todas las Rooms
	#luego ira tomando una habitacion visitada y la conectara con una no visitada hasta finalizar
	#esto nos asegura que no quedaran habitaciones inaccesibles en el mapa, es importante!
	var visitedRooms=[]
	var unvisitedRooms=ROOMS
	var num=rnd.randi_range(0, unvisitedRooms.size()-1)
	visitedRooms.append(unvisitedRooms[num])
	unvisitedRooms.remove(num)
	while unvisitedRooms.size()>0:
		var num_v=rnd.randi_range(0, visitedRooms.size()-1)
		var num_u=rnd.randi_range(0, unvisitedRooms.size()-1)
		crearPasillo(visitedRooms[num_v],unvisitedRooms[num_u])
		visitedRooms.append(unvisitedRooms[num_u])
		unvisitedRooms.remove(num_u)
	ROOMS=visitedRooms

func finishMap(map):
	#lena el espacio libre con bloques no caminables y establece los muros del mapa
	for x in range(map.size()):
		for y in range(map[0].size()):
			if map[x][y]==tiles["LIBRE"]: map[x][y]=tiles["BLOQUEADO"]

func iniFog():
	for x in range(map_w):
		for y in range(map_h):
			get_node("/root/Node2D/Nav2D/FogMap").set_cell(x,y,0)
	#get_node("/root/Node2D/Nav2D/FogMap").update_bitmask_region()

func showFog(px,py,ran):
#	for x in range(px-rango,px+rango):
#		for y in range(py-rango,py+rango):
#			if x<0: continue
#			elif x>map_w: continue
#			if y<0: continue
#			elif y>map_h: continue
#			get_node("/root/Node2D/Nav2D/FogMap").set_cell(x,y,-1)
	linearRevealFog(px,py,ran)
	#AUTOTILE UPDATE IS PESADE
	#get_node("/root/Node2D/Nav2D/FogMap").update_bitmask_region(Vector2(px-ran,py-ran),Vector2(px+ran,py+ran))
#	var rmap=[]
#	rmap.resize(ran*ran)
#	recursiveFog(px,py,px,py,ran,rmap)

func recursiveFog(ox,oy,x,y,ran,rmap):	
	get_node("/root/Node2D/Nav2D/FogMap").set_cell(x,y,-1)
	if ran==0: return #si no hay mas rango
	if rmap[(x-ox)*ran+(y-oy)]==1: return #si ya fue visitado
	#o si no permite pasar la vision, RETORNA
	if DATAMAP[x][y]!=tiles["SUELO"] and DATAMAP[x][y]!=tiles["PASILLO"]: return
	# de lo contrario actua con sus vecinos
	rmap[(x-ox)*ran+(y-oy)]=1
	for nx in range(x-1,x+2):
		for ny in range(y-1,y+2):
			recursiveFog(ox,oy,nx,ny,ran-1,rmap)

func linearRevealFog(ox,oy,ran):
	var fog_map=get_node("/root/Node2D/Nav2D/FogMap")
	linearRectLinesFog(ox,oy,ran)
	for x in range(ox-ran,ox+ran+1):
		var dx=(x-ox)/ran
		for i in range(ran):
			fog_map.set_cell(ox+i*dx, oy+i, -1)
			if isOcluder(ox+i*dx, oy+i): break
		for i in range(ran):
			fog_map.set_cell(ox+i*dx, oy-i, -1)
			if isOcluder(ox+i*dx, oy-i): break
	
	for y in range(oy-ran,oy+ran+1):
		var dy=(y-oy)/ran
		for i in range(ran):
			fog_map.set_cell(ox+i, oy+i*dy, -1)
			if isOcluder(ox+i, oy+i*dy): break
		for i in range(ran):
			fog_map.set_cell(ox-i, oy+i*dy, -1)
			if isOcluder(ox-i, oy+i*dy): break

func linearRectLinesFog(ox,oy,ran):
	var fog_map=get_node("/root/Node2D/Nav2D/FogMap")
	for x in range(ox,ox+ran):
		fog_map.set_cell(x, oy-1, -1)
		fog_map.set_cell(x, oy, -1)
		fog_map.set_cell(x, oy+1, -1)
		if isOcluder(x, oy): break
	for x in range(ox,ox-ran,-1):
		fog_map.set_cell(x, oy-1, -1)
		fog_map.set_cell(x, oy, -1)
		fog_map.set_cell(x, oy+1, -1)
		if isOcluder(x, oy): break
	for y in range(oy,oy+ran):
		fog_map.set_cell(ox-1, y, -1)
		fog_map.set_cell(ox, y, -1)
		fog_map.set_cell(ox+1, y, -1)
		if isOcluder(ox, y): break
	for y in range(oy,oy-ran,-1):
		fog_map.set_cell(ox-1, y, -1)
		fog_map.set_cell(ox, y, -1)
		fog_map.set_cell(ox+1, y, -1)
		if isOcluder(ox, y): break

func isOcluder(x,y):
	if DATAMAP[x][y]==tiles["MURO"]: return true
	if DATAMAP[x][y]==tiles["BLOQUEADO"]: return true
	if DATAMAP[x][y]==tiles["PUERTA"]: return true
	return false

func addDoors():
	var cnt=0
	for i in range(1000):
		if cnt >= 3+Globals.rndi(NIVEL,NIVEL*2): break
		var xx=Globals.rndi(1,map_w-2)
		var yy=Globals.rndi(1,map_h-2)
		if isViableDoor(xx,yy):
			cnt+=1
			DATAMAP[xx][yy]=tiles["PUERTA"]
			#print("add DOOR in "+str(xx)+","+str(yy))

func isViableDoor(xx,yy):
	if traversablesIndexs.has(DATAMAP[xx-1][yy]) and traversablesIndexs.has(DATAMAP[xx+1][yy]):
		if !traversablesIndexs.has(DATAMAP[xx][yy-1]) and !traversablesIndexs.has(DATAMAP[xx][yy+1]):
			return true
	if traversablesIndexs.has(DATAMAP[xx][yy-1]) and traversablesIndexs.has(DATAMAP[xx][yy+1]):
		if !traversablesIndexs.has(DATAMAP[xx-1][yy]) and !traversablesIndexs.has(DATAMAP[xx+1][yy]):
			return true 
	return false
	
func addEnemies():
	var cnt= 1+Globals.rndi(NIVEL,NIVEL*2)
	for i in range(cnt):
		for j in range(50):
			var xx=Globals.rndi(1,map_w-2)
			var yy=Globals.rndi(1,map_h-2)
			if Vector2(ROOMS[0]["cx"],ROOMS[0]["cy"]).distance_to(Vector2(xx,yy))<4: continue
			if DATAMAP[xx][yy]!=tiles["SUELO"]: continue
			
			Globals.EnemiesManager.random_enemy(NIVEL,Vector2(xx,yy))
			break

func addChests():
	for i in range(1+floor(NIVEL/2)):
		for j in range(50):
			var xx=Globals.rndi(1,map_w-2)
			var yy=Globals.rndi(1,map_h-2)
			if Globals.TilemapManager.get_element(Vector2(xx,yy),"OBJECTS"): continue
			if DATAMAP[xx][yy]==tiles["SUELO"]:
				Globals.ItemsManager.createChest(Vector2(xx,yy))
				break
			

func addAltar():
	for j in range(50):
		var xx=Globals.rndi(1,map_w-2)
		var yy=Globals.rndi(1,map_h-2)
		if Globals.TilemapManager.get_element(Vector2(xx,yy),"OBJECTS"): continue
		if DATAMAP[xx][yy]==tiles["SUELO"]:
			Globals.ItemsManager.createAltar(Vector2(xx,yy))
			break

func addFuente():
	for j in range(50):
		var xx=Globals.rndi(1,map_w-2)
		var yy=Globals.rndi(1,map_h-2)
		if Globals.TilemapManager.get_element(Vector2(xx,yy),"OBJECTS"): continue
		if DATAMAP[xx][yy]==tiles["SUELO"]:
			Globals.ItemsManager.createFuente(Vector2(xx,yy))
			break

