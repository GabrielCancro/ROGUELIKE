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
	update_stats_UI()

func _process(delta):
	pass

func update_stats_UI():
	var ATTRS=Globals.player.ATTRIBUTABLE
	
	var STR=" hp: "+str( ATTRS.get_attr(".hp") )+"/"+str( ATTRS.get_attr("hp") )+"\n"
	STR+=" pp: "+str( ATTRS.get_attr(".pp") )+"/"+str( ATTRS.get_attr("pp") )+"\n\n"
	get_node("GUI_STATS/hppp_label").set_text(STR)
	
	STR=""
	var showAttr=["atk","def","pow","res",]
	for at in showAttr: STR+=at+" "+str( ATTRS.get_attr(at) )+"\n"
	get_node("GUI_STATS/attr_label").set_text(STR)