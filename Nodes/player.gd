extends Node2D

onready var TILEABLE = preload('res://Class/Tileable.gd').new(self)
onready var MOVIBLE = preload('res://Class/Movible.gd').new(self)
onready var ATTRIBUTABLE = preload('res://Class/Attributable.gd').new(self)
onready var ABILITYABLE = preload('res://Class/Abilityable.gd').new(self)
onready var INVENTARIABLE = preload('res://Class/Inventariable.gd').new(self)

var speed = 20
var STATE="MOVE"
var currentBag

onready var nav_2D:Navigation2D=get_node("../Nav2D")
onready var menu=get_node("../RootMenu")

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.TurnController.add_to_list(self)
	yield(get_tree().create_timer(0.2), "timeout")
	var iniPos=Globals.dunGen.generateDungeon(Globals.tile_map)
	TILEABLE.set_tile_pos(iniPos)
	Globals.dunGen.showFog(iniPos.x,iniPos.y,ATTRIBUTABLE.get_attr("see"))
	ATTRIBUTABLE.set_attr("hp",12)
	ATTRIBUTABLE.set_attr(".hp",12)

func get_input():
	var v = Vector2(0,0)
	if Input.is_action_pressed('ui_right'): v.x += 1
	elif Input.is_action_pressed('ui_left'): v.x -= 1
	elif Input.is_action_pressed('ui_down'): v.y += 1
	elif Input.is_action_pressed('ui_up'): v.y -= 1	
	##if moveToPath: movePath()
	##elif v.x!=0 || v.y!=0:
	if v.x!=0 || v.y!=0:
		var myTileDes=TILEABLE.get_tile_pos()+v
		MOVIBLE.set_tile_des(myTileDes)
	if Input.is_action_just_released('ui_accept'): 
			setState("MENU")
			menu.showRootMenu(self)
	if Input.is_action_just_released('ui_cancel'): 
			ATTRIBUTABLE.print_all_attr()
			ABILITYABLE.print_all_habs()
	if Input.is_action_just_released('ui_select'): 
		var iniPos=Globals.dunGen.generateDungeon(Globals.tile_map)
		TILEABLE.set_tile_pos(iniPos)
		Globals.dunGen.showFog(iniPos.x,iniPos.y,ATTRIBUTABLE.get_attr("see"))
	if Input.is_action_just_released('toggle_mode'):
		#print(str(Globals.soundManager.get_playback_position()))
		print(str(Globals.TilemapManager.GR_ENEMIES))
		pass

func setState(_state):
	yield(get_tree().create_timer(0.1), "timeout")
	STATE=_state

func on_exit_menu(data):
	if data["action"]=="NONE": 
		setState("MOVE")
	elif data["action"]=="CAST":
		showSelectorTilePos(data)
	elif data["action"]=="HAB":
		Globals.HabsManager.ejecutarHab(self,data)
		yield(get_tree().create_timer(.5), "timeout")
		setState("MOVE")
	

func on_exit_selector(data):
	if data.has("tilePos"):
		set_work("OPEN",data.get("tilePos"))		
	else: 
		setState("MOVE")

func _process(delta):
	get_node('/root/Node2D/UIControl/STATE_Label').set_text("S: "+STATE)
	MOVIBLE.moveToDest()
	

func processTravel():	
	if !MOVIBLE.isMoving and STATE=="MOVE": get_input()
	
var steps=0
func onEnterTurn():
	steps=5

func processTurn():
	if STATE=="MOVE":
		if steps<=0:
			Globals.turnController.finishTurn(self)
			return
		if !MOVIBLE.isMoving: 
			get_input()


func checkTileDest(tile_des):
	print("CHECK TILE DES "+str(tile_des))
	# 1..si hay enemigo lo ataca	
	var enem=Globals.TilemapManager.get_element(tile_des,"ENEMIES")
	if enem!=null: 
		Globals.DDCORE.attack(self,enem)
		Globals.turnController.finishTurn(self)
		return false
	# 2.. si hay puerta la intenta abrir
	var cell_des=Globals.tile_map.get_cellv(tile_des)
	if cell_des==8:
		set_work("OPEN",tile_des)
		Globals.turnController.finishTurn(self)
		return false
	# 3.. si hay enemigos cerca   NO ES MUY OPTIMO
	if !Globals.turnController.isTurnMode:
		var enemiGroup=Globals.TilemapManager.get_elements_in_area(tile_des,6,"ENEMIES")
		if enemiGroup.size()>0: 
			Globals.turnController.set_turn_mode()
	else:
		var enemiGroup=Globals.TilemapManager.get_elements_in_area(tile_des,10,"ENEMIES")
		print("ENEMI GROUP AREA l108 "+str(enemiGroup))
		if enemiGroup.size()==0: Globals.turnController.set_turn_mode(false)
	# 4.. si hay un items
	var bag=Globals.TilemapManager.get_element(tile_des,"OBJECTS")
	if bag!=null:
		currentBag=bag
		setState("MENU")
		menu.showRootMenu(self,"MenuITEMS")
		steps=2
	# 5 .. si te moves en modo combate
	if Globals.turnController.isTurnMode:
		steps-=1
		Globals.effectManager.text_effect(position,':'+str(steps))		
	return true


func set_work(name,pos):
	STATE="WORK"
	steps=0
	if(name=="OPEN"):
		Globals.effectManager.work_effect(pos,2.0)
		yield(get_tree().create_timer(2.0), "timeout")
		Globals.tile_map.set_cell(pos.x,pos.y,10)
		Globals.turnController.finishTurn(self)
		STATE="MOVE"

func showSelectorTilePos(data):
	STATE="TILE_SELECTOR"
	var SPJ=get_node("../UIControl/SelectPj")
	SPJ.showSelector(self,data)

func dead():
	pass	