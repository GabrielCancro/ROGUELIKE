extends CanvasLayer

var tile_map:TileMap;
var cellSize;
var CONCAT_STR=""
onready var con1=Globals.player.ATTRIBUTABLE.connect("sg_change_attr",self,"updateGUI")
onready var con3=Globals.player.STATEABLE.connect("sg_change_state",self,"updateGUI")


func _ready():
	tile_map = get_node("/root/Node2D/Nav2D/TileMap");
	cellSize=tile_map.cell_size;
	clear_info_lines()
	updateGUI_states()
	$Botones.text="["+Globals.BTNS[0]+"] Aceptar\n     ["+Globals.BTNS[1]+"] Cancelar\n"
	$button_map.connect("pressed",self,"map_click")
	$button_skip_tuto.connect("pressed",self,"skip_tuto")
	$button_skip_tuto.visible=false

func updateGUI():
	update_attr_UI()
	update_gui_steps()
	updateGUI_states()
	
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

func update_attr_UI():
	$scores_label.text=str(Globals.OPTIONS.DATA_SAVE["score"])
	var ATTRS=Globals.player.ATTRIBUTABLE
	var hptxt=str( ATTRS.get_attr(".hp") )+"/"+str( ATTRS.get_attr("hp") )
	var pptxt=str( ATTRS.get_attr(".pp") )+"/"+str( ATTRS.get_attr("pp") )
	
	get_node("GUI_STATS/ui_up/hp_lbl").set_text(hptxt)
	if ATTRS.get_attr("hp")>0:
		get_node("GUI_STATS/ui_up/hp_bar").value=ATTRS.get_attr(".hp")*100/ATTRS.get_attr("hp")
	get_node("GUI_STATS/ui_up/pp_lbl").set_text(pptxt)
	if ATTRS.get_attr("pp")>0:
		get_node("GUI_STATS/ui_up/pp_bar").value=ATTRS.get_attr(".pp")*100/ATTRS.get_attr("pp")

	var STR=""
	var showAttr=["atk","def","dan","pow"]
	STR+="[color=#FFA] atk "+str( ATTRS.get_attr("atk") )+"[/color]\n"
	STR+="[color=#AAA] def "+str( ATTRS.get_attr("def") )+"[/color]\n"
	STR+="[color=#FAA] dan "+str( ATTRS.get_attr("dan") )+"[/color]\n"
	STR+="[color=#AAF] pow "+str( ATTRS.get_attr("pow") )+"[/color]\n"
	get_node("GUI_STATS/ui_left/attr_rlbl").bbcode_text=STR

func updateGUI_states():
	$GUI_STATS.get_node("states_label").set_text( Globals.player.STATEABLE.get_all_states_info() )
	$GUI_STATS.get_node("states_desc").set_text( Globals.player.STATEABLE.get_all_states_desc() )
	
func update_labal_level(lvl):
	$Label_Level.set_text("Profundidad "+str(lvl))

func update_gui_steps():
	var steps=Globals.player.ATTRIBUTABLE.get_attr(".stp")
	$GUI_STATS/ui_up/stp_lbl.text
	var tx=""
	for i in range(0,steps): tx+="o "
	$GUI_STATS/ui_up/stp_lbl.text=tx

func map_click():
	if Globals.camera.zoom.x==1: Globals.camera.zoom=Vector2(4,4)
	else: Globals.camera.zoom=Vector2(1,1)

func skip_tuto():
	$button_skip_tuto.visible=false
	Globals.player.TILEABLE.set_tile_pos(Vector2(6,6))
	Globals.tile_map.set_cell(7,6,Globals.dunGen.tiles["MURO"])
	Globals.dunGen.DATAMAP[7][6]=Globals.dunGen.tiles["MURO"]
	Globals.player.checkTileDest(Vector2(6,6))
