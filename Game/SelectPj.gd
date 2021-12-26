extends Sprite

var tilePos=Vector2(0,0)
var data
var own

signal onSelectTile

func _ready(): 
	hideSelector()

func showSelector(_pj,_data):
	yield(get_tree().create_timer(0.2), "timeout")
	visible=true
	set_process(true)
	own=_pj
	data=_data
	data["ran"]=data.get("ran",5)
	tilePos=own.TILEABLE.get_tile_pos()
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
	
	var dist=(tilePos+v)-own.TILEABLE.get_tile_pos()
	if abs(dist.x)>=data["ran"] or abs(dist.y)>=data["ran"]: return
	
	if v.length()!=0: 
		tilePos+=v
		redrawSelector()
	if Input.is_action_just_released('ui_accept'):
		Globals.SoundsManager.play_sfx("UI_accept")
		data["tilePos"]=tilePos
		own.on_exit_selector(data)
		hideSelector()
	if Input.is_action_just_released('ui_cancel'):
		own.on_exit_selector({"action":"NONE"})
		hideSelector()

func redrawSelector():
	var cell_size=Globals.tile_map.cell_size
	set_position(tilePos*cell_size+cell_size/2)
	$Label.set_text(str(tilePos.x)+","+str(tilePos.y))


func _process(delta):
	myInputs()
