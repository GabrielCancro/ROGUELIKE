extends CanvasLayer

var tile_map:TileMap;
var cellSize;
var selectSprite;
onready var con1=Globals.player.ATTRIBUTABLE.connect("sg_change_attr",self,"updateGUI")

func _ready():
	tile_map = get_node("/root/Node2D/Nav2D/TileMap");
	cellSize=tile_map.cell_size;
	selectSprite = $Select;	

func updateGUI(attr,cnt):
	print("UPDATEHP")
	update_stats_UI()
	if attr==".hp":
		get_node("HPLabel").set_text("VIDA PJ: "+str(cnt) )

func _process(delta):
	pass

func update_stats_UI():
	print("update ui stats")
	var ATTRS=Globals.player.ATTRIBUTABLE
	var LBL=get_node("GUI_STATS/attr_label")
	var STR=" hp: "+str( ATTRS.get_attr(".hp") )+"/"+str( ATTRS.get_attr("hp") )+"\n"
	STR+=" pp: "+str( ATTRS.get_attr(".pp") )+"/"+str( ATTRS.get_attr("pp") )+"\n\n"
	var showAttr=["atk","def","pow","res",]
	for at in showAttr: STR+=at+" "+str( ATTRS.get_attr(at) )+"\n"
	LBL.set_text(STR)