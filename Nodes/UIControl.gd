extends CanvasLayer

var tile_map:TileMap;
var cellSize;
var CONCAT_STR=""
onready var con1=Globals.player.ATTRIBUTABLE.connect("sg_change_attr",self,"updateGUI")

func _ready():
	tile_map = get_node("/root/Node2D/Nav2D/TileMap");
	cellSize=tile_map.cell_size;
	clear_info_lines()

func updateGUI(attr,cnt):
	update_stats_UI()
	
func _process(delta):
	pass

func add_info_concat(STR):
	CONCAT_STR+=STR

func add_info_line(STR="ADD_CONCATENATE_LINE"):
	if STR=="ADD_CONCATENATE_LINE":
		STR=CONCAT_STR
		CONCAT_STR=""
	$Info_lines.get_node("Line1").set_text( $Info_lines.get_node("Line2").get_text() )
	$Info_lines.get_node("Line2").set_text( $Info_lines.get_node("Line3").get_text() )
	$Info_lines.get_node("Line3").set_text( STR )

func clear_info_lines():
	$Info_lines.get_node("Line1").set_text("")
	$Info_lines.get_node("Line2").set_text("")
	$Info_lines.get_node("Line3").set_text("")

func update_stats_UI():
	var ATTRS=Globals.player.ATTRIBUTABLE
	
	var STR=" hp: "+str( ATTRS.get_attr(".hp") )+"/"+str( ATTRS.get_attr("hp") )+"\n"
	STR+=" pp: "+str( ATTRS.get_attr(".pp") )+"/"+str( ATTRS.get_attr("pp") )+"\n\n"
	get_node("GUI_STATS/hppp_label").set_text(STR)
	
	STR=""
	var showAttr=["atk","def","pow","res",]
	for at in showAttr: STR+=at+" "+str( ATTRS.get_attr(at) )+"\n"
	get_node("GUI_STATS/attr_label").set_text(STR)