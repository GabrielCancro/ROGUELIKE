class_name Movible

var own
var tile_des=null
var world_des
var isMoving=false
var delayMove=0
var steps=0

func _init(_owner):
	own=_owner
	own.set_z_index(10+own.TILEABLE.get_tile_pos().y)
	#print (own.name+" is movible init")

func update():
	pass

func set_tile_des(d):
	if delayMove>0: return
	if tile_des==null:
		tile_des=d
		world_des=Globals.tile_map.map_to_world(tile_des)+Globals.tile_map.cell_size/2
		
		var myTilePos=own.TILEABLE.get_tile_pos()
		if tile_des.x!=myTilePos.x: own.get_node( "Sprite" ).set_flip_h( tile_des.x<myTilePos.x )
		if ( own.has_method("checkTileDest") and !own.checkTileDest(tile_des) ) or !moveAction(tile_des): 
			tile_des=null
			delayMove=20
			return
		own.set_z_index(10+tile_des.y)
		steps+=1

func moveToDest():
	if delayMove>0:
		delayMove-=1
		return
	isMoving=tile_des!=null
	if tile_des!=null:
		if own.position.distance_to(world_des)>1:
			own.position+=(world_des-own.position)/100*own.speed
		else:
			own.TILEABLE.set_tile_pos(tile_des)
			tile_des=null


func moveAction(des):
	var cell_des=Globals.tile_map.get_cellv(des)
	if(cell_des==3 || cell_des==10):
		if own.name=='Player': Globals.dunGen.showFog(des.x,des.y,6)
		return true #true if is posible move