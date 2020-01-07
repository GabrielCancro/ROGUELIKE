extends Node2D

onready var MOVIBLE = preload('res://Class/Movible.gd').new(self)
# Declare member variables here. Examples:
var speed = 20
var STATE="MOVE"

signal onChangeHp

onready var nav_2D:Navigation2D=get_node("../Nav2D")
onready var dunGen=get_node("/root/Node2D/DungeonGenerator")
onready var menu=get_node("../RootMenu")
onready var data=get_node("data")

# Called when the node enters the scene tree for the first time.
func _ready():
	position=Vector2(7,5)*Globals.tile_size+Globals.tile_size/2
	Globals.TurnController.add_to_list(self)
	yield(get_tree().create_timer(0.2), "timeout")
	addHp(0)
	var iniPos=dunGen.generateDungeon(Globals.tile_map)
	position=iniPos*Globals.tile_size+Globals.tile_size/2
	dunGen.showFog(iniPos.x,iniPos.y,3)

func get_input():
# Detect up/down/left/right keystate and only move when pressed.
	var v = Vector2(0,0)
	if Input.is_action_pressed('ui_right'): v.x += 1
	if Input.is_action_pressed('ui_left'): v.x -= 1
	if Input.is_action_pressed('ui_down'): v.y += 1
	if Input.is_action_pressed('ui_up'): v.y -= 1
	if v.x!=0: get_node( "Sprite" ).set_flip_h( v.x==-1 )
	##if moveToPath: movePath()
	##elif v.x!=0 || v.y!=0:
	if v.x!=0 || v.y!=0:
		var myTileDes=getTilePos()+v
		MOVIBLE.set_tile_des(myTileDes)
	if Input.is_action_just_released('ui_accept'): 
			setState("MENU")
			menu.showRootMenu(self)
	if Input.is_action_just_released('ui_select'): 
		var iniPos=dunGen.generateDungeon(Globals.tile_map)
		position=iniPos*Vector2(32,32)+Globals.tile_size/2
		dunGen.showFog(iniPos.x,iniPos.y,3)
	if Input.is_action_just_released('toggle_mode'): 
		Globals.turnController.isTurnMode=!Globals.turnController.isTurnMode

func setState(_state):
	yield(get_tree().create_timer(0.1), "timeout")
	STATE=_state

func on_exit_menu(data):
	if data["action"]=="NONE": 
		setState("MOVE")
	elif data["action"]=="CAST":
		showSelectorTilePos(data)

func on_exit_selector(data):
	if data.has("tilePos"):
		set_work("OPEN",data.get("tilePos"))
	else: setState("MOVE")

func getTilePos():
	return Globals.tile_map.world_to_map(position)

func _process(delta):
	get_node('/root/Node2D/UIControl/STATE_Label').set_text("S: "+STATE)
	MOVIBLE.moveToDest()

func processTravel():	
	if STATE=="MOVE": get_input()
	
var steps=0
func onEnterTurn():
	Globals.effectManager.text_effect(position,'you turn!',0.5)
	steps=5

var oneTurnShoot=false
func processTurn():
	if steps<=0:
		Globals.turnController.finishTurn(self)
		return
		
	if !MOVIBLE.isMoving: 
		if STATE=="MOVE": get_input()
		if oneTurnShoot:			
			steps-=1
			oneTurnShoot=false
	elif !oneTurnShoot: 
		Globals.effectManager.text_effect(position,':'+str(steps-1),1)
		oneTurnShoot=true

func moveAction(des):
	var cell_des=Globals.tile_map.get_cellv(des)
	if cell_des==8:
		set_work("OPEN",des)
		return false
	else: return false

func set_work(name,pos):
	STATE="WORK"
	if(name=="OPEN"):
		Globals.effectManager.work_effect(pos,2.0)
		yield(get_tree().create_timer(2.0), "timeout")
		Globals.tile_map.set_cell(pos.x,pos.y,10)
		steps=0
		STATE="MOVE"

func addHp(num):
	print("PLAYER.addHp "+str(num))
	data.baseAttr[".hp"]+=num
	emit_signal("onChangeHp", data.baseAttr[".hp"], data.baseAttr["hp"])

func showSelectorTilePos(data):
	STATE="TILE_SELECTOR"
	var SPJ=get_node("../UIControl/SelectPj")
	SPJ.showSelector(self,data)