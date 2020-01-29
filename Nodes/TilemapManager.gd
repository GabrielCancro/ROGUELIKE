extends Node

# Declare member variables here. Examples:
var GR_ENEMIES = {}
var GR_OBJECTS = {}
#var traps_group = {}
#var secrets_group = {}

#func add_to_tilegroup(obj, groupName):
#	if groupName=="ENEMIES": ENEMIES.append(obj)
#	elif groupName=="OBJECTS": OBJECTS.append(obj)
#	else: push_error("NO EXISTE EL GRUPO "+groupName)

func reindex_tilegroup(obj, last_pos, new_pos):
	var GRP=get_group(obj.TILEABLE.tile_group)
	GRP.erase(get_id(last_pos))
	GRP[get_id(new_pos)]=obj

func remove_to_tilegroup(obj, groupName):
	get_group(groupName).erase( get_id( obj.TILEABLE.get_tile_pos() ) )

func get_element(pos,groupName):
	return get_group(groupName).get( get_id(pos) )
	

func get_elements_in_area(pos,ran,groupName):
	var GRP=get_group(groupName)
	var RESULT=[]
	for xx in range(pos.x-ran,pos.x+ran):
		for yy in range(pos.y-ran,pos.y+ran):
			var EL=GRP.get( get_id(Vector2(xx,yy)) )
			if EL!=null: RESULT.append(EL)
	
	return RESULT

func get_obstacles_in_area(pos,ran):
	#si hay obstaculo devuelve coloca un 1
	var GRP=get_group("ENEMIES")
	var R = []
	for xx in range(-ran,ran):
		var col = []
		for yy in range(-ran,ran):
			if GRP.get( get_id(Vector2(pos.x+xx,pos.y+yy)) ): col.append(1)
			else: col.append(0)
		R.append(col)
	return R

#privates functions
func get_id(pos):
	return pos.x*10000+pos.y

func get_group(groupName):
	if groupName=="ENEMIES": return GR_ENEMIES
	elif groupName=="OBJECTS": return GR_OBJECTS
	else: push_error("NO EXISTE EL GRUPO "+groupName)
	return