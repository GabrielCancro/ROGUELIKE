#extends Node2D
class_name AstarClass

var astar
var diagonalMovements=false
onready var traversable_tiles

func setAstar(grid,traversablesIndexs=[1]): #grid is array[x][y] or array[Vector2]
	print("ASTAR seting")
	if typeof(grid[0])==TYPE_VECTOR2:
		traversable_tiles=grid
		#error!!! no hay que agregar toda la grilla a los atravesables!!!
	elif typeof(grid[0])==TYPE_ARRAY:
		traversable_tiles=[]
		for x in range(grid.size()):
			for y in range(grid[x].size()):
					if traversablesIndexs.has(grid[x][y]) :
						traversable_tiles.append(Vector2(x,y))
	astar=AStar.new()
	_add_traversable_tiles(traversable_tiles)
	_connect_traversable_tiles(traversable_tiles)
	print("set_ok!")
	return true

func _add_traversable_tiles(traversable_tiles):
	for tile in traversable_tiles:
		var id = _get_id_for_point(tile)
		astar.add_point(id, Vector3(tile.x, tile.y, 0))

func _connect_traversable_tiles(traversable_tiles):
	for tile in traversable_tiles:
		var id = _get_id_for_point(tile)
		for x in range(3):
			for y in range(3):				
				var target = tile + Vector2(x - 1, y - 1)
				var target_id = _get_id_for_point(target)
				if tile == target or not astar.has_point(target_id):
					continue
				if !diagonalMovements and x-1!=0 and y-1!=0: continue #skip diagonal movements
				astar.connect_points(id, target_id, true)

func _get_id_for_point(point):
	return point.x*100000 + point.y


## Public function
func get_astar_path(start_tile, end_tile):
	# Determines IDs
	var start_id = _get_id_for_point(start_tile)
	var end_id = _get_id_for_point(end_tile)
	
	# Return null if navigation is impossible
	if not astar.has_point(start_id) or not astar.has_point(end_id):
		return null
	
	# Otherwise, find the map
	var path_map = astar.get_point_path(start_id, end_id)
	
	# Convert Vector3 array 2D points
	var path_world = []
	for point in path_map:
		var point2D=Vector2(point.x, point.y)
		path_world.append(point2D)
	return path_world