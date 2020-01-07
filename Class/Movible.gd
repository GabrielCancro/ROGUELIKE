class_name Movible

var own
var tile_des=null
var world_des
var isMoving=false
var steps=0
#requiere speed y func moveAction(des)

func _init(_owner):
	own=_owner
	own.set_z_index(10+own.getTilePos().y)
	print (own.name+" is movible init")

func update():
	pass

func set_tile_des(d):
	if tile_des==null:
		tile_des=d
		world_des=Globals.tile_map.map_to_world(tile_des)+Globals.tile_map.cell_size/2
		own.set_z_index(10+tile_des.y)
		steps+=1

func moveToDest():
	isMoving=tile_des!=null
	if tile_des!=null:
		if moveAction(tile_des):
			if own.position.distance_to(world_des)>1:
				own.position+=(world_des-own.position)/100*own.speed
			else: 				
				tile_des=null
		else:
			tile_des=null

func moveAction(des):
	var cell_des=Globals.tile_map.get_cellv(des)
	if(cell_des==3 || cell_des==10):
		if own.name=='Player': Globals.dunGen.showFog(des.x,des.y,6)
		return true #true if is posible move
	elif own.has_method("moveAction"):
		return own.moveAction(des)