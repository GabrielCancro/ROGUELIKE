extends Control

var tile_map:TileMap;
var cellSize;
var selectSprite;

func _ready():
	tile_map = get_node("../Nav2D/TileMap");
	cellSize=tile_map.cell_size;
	selectSprite = $Select;

func _process(delta):
	var mousePos=get_viewport().get_mouse_position();
	var mapPos=tile_map.world_to_map( mousePos );
	var myCellDes=tile_map.get_cellv(mapPos)
	$Label.set_text(str(mapPos.x)+","+str(mapPos.y)+" : "+str(myCellDes));
	selectSprite.set_position(mapPos*cellSize+cellSize/2);