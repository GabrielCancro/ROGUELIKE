extends CanvasLayer

var tile_map:TileMap;
var cellSize;
var selectSprite;

func _ready():
	tile_map = get_node("/root/Node2D/Nav2D/TileMap");
	cellSize=tile_map.cell_size;
	selectSprite = $Select;
	print("player is "+get_node("/root/Node2D/Player").name)
	get_node("/root/Node2D/Player").connect("onChangeHp", self, "updateHp")
	get_node("HPLabel").set_text("VIDA PJ: "+str(get_node("/root/Node2D/Player").data.baseAttr[".hp"]))

func updateHp(hp,hpMax):
	print("UPDATEHP")
	get_node("HPLabel").set_text("VIDA PJ: "+str(hp))

func _process(delta):
	var mousePos=get_viewport().get_mouse_position();
	var camPos=get_node("/root/Node2D/Camera2D").get_camera_position()-get_viewport().size/2
	var mapPos=tile_map.world_to_map( mousePos+camPos );
	var myCellDes=tile_map.get_cellv(mapPos)
	$Label.set_text(str(mapPos.x)+","+str(mapPos.y)+" : "+str(myCellDes));
	selectSprite.set_position((mapPos)*cellSize+cellSize/2-camPos);