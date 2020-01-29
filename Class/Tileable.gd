class_name Tileable

var own
var tile_group
var tile_pos:Vector2

func _init(_owner,my_tile_group=""):
	own=_owner
	tile_group=my_tile_group

func set_tile_pos(newTilePos):
	if(tile_group!=""):
		Globals.TilemapManager.reindex_tilegroup(own,tile_pos,newTilePos)		
	tile_pos=newTilePos
	update_position()

func get_tile_pos():
	autoset_tile_pos()
	return tile_pos

func autoset_tile_pos():
	tile_pos=Globals.tile_map.world_to_map(own.get_position())
	return tile_pos

func update_position():
	var world_pos=Globals.tile_map.map_to_world(tile_pos)+Globals.tile_map.cell_size/2
	own.set_position(world_pos)