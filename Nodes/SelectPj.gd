extends Sprite

var tilePos=Vector2(0,0)
var data
var pj

onready var tile_map:TileMap = get_tree().get_root().get_node("Node2D/Nav2D/TileMap")
onready var cellSize=tile_map.cell_size
onready var mainCam:Camera2D=get_node('/root/Node2D/Camera2D')

signal onSelectTile

func _ready(): 
	hideSelector()

func showSelector(_pj,_data):
	yield(get_tree().create_timer(0.2), "timeout")
	visible=true
	set_process(true)
	pj=_pj
	data=_data
	tilePos=pj.TILEABLE.get_tile_pos()
	redrawSelector()

func hideSelector():
	visible=false
	set_process(false)

func myInputs():
	var v:Vector2=Vector2(0,0)
	if Input.is_action_just_pressed('ui_right'): v.x += 1
	if Input.is_action_just_pressed('ui_left'): v.x -= 1
	if Input.is_action_just_pressed('ui_down'): v.y += 1
	if Input.is_action_just_pressed('ui_up'): v.y -= 1	
	if v.length()!=0: 
		tilePos+=v
		redrawSelector()	
	if Input.is_action_just_released('ui_accept'):		
		data["tilePos"]=tilePos
		pj.on_exit_selector(data)
		hideSelector()
	if Input.is_action_just_released('ui_cancel'):
		pj.on_exit_selector({"action":"NONE"})
		hideSelector()

func redrawSelector():
	var camPos=get_node("/root/Node2D/Camera2D").get_camera_position()-get_viewport().size/2
	set_position(tilePos*cellSize+cellSize/2-camPos)
	$Label.set_text(str(tilePos.x)+","+str(tilePos.y))
	
	var strObjeto=""
	for obj in get_tree().get_nodes_in_group("objetos"):
		if obj.getTilePos()==tilePos: strObjeto+=obj.name+"\n"
	
	var cell=tile_map.get_cellv(tilePos)
	if cell==8: strObjeto+="door"
	elif cell!=3: strObjeto+="blocked"

	$LabelObj.set_text(strObjeto)

func _process(delta):
	myInputs()
