extends Node2D

onready var TILEABLE = preload('res://Class/Tileable.gd').new(self)
onready var MOVIBLE = preload('res://Class/Movible.gd').new(self)
onready var ATTRIBUTABLE = preload('res://Class/Attributable.gd').new(self)
onready var ABILITYABLE = preload('res://Class/Abilityable.gd').new(self)
onready var INVENTARIABLE = preload('res://Class/Inventariable.gd').new(self)

var speed = 20
var STATE="MOVE"
var isDead=false
var currentBag

onready var nav_2D:Navigation2D=get_node("../Nav2D")
onready var menu=get_node("../RootMenu")

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.TurnController.add_to_list(self)
	yield(get_tree().create_timer(0.2), "timeout")
	Globals.dunGen.generateDungeon(Globals.tile_map)
	
	ATTRIBUTABLE.set_attr("hp",7)
	ATTRIBUTABLE.set_attr(".hp",7)
	
	ATTRIBUTABLE.set_attr("pp",2)
	ATTRIBUTABLE.set_attr(".pp",2)
	
	ABILITYABLE.set_base_hab("BERSERK",5)
	#ABILITYABLE.set_base_hab("PUNTERIA",3)
	#ABILITYABLE.set_base_hab("ARQUERIA",3)
	ABILITYABLE.set_base_hab("DEBILITAR",1)
	
	#INVENTARIABLE.addItem(201,2)

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
		pass
		#Globals.dunGen.generateDungeon(Globals.tile_map)
	if Input.is_action_just_released('toggle_mode'):
		print(str(Globals.TilemapManager.GR_ENEMIES))
		#get_tree().change_scene("res://Nodes/menuPrincipal/menu_principal.tscn")
		#Globals.DeathAnimation.ThePlayerDied()
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
	

func on_exit_selector(data):
	#print("on_exit_selector: "+str(data))
	if data.has("tilePos"):
		if data.has("action") and data["action"]=="HAB":
			Globals.HabsManager.ejecutarHabInPos(self,data)
	else: 
		yield(get_tree().create_timer(.5), "timeout")
		setState("MOVE")

func _process(delta):
	get_node('/root/Node2D/UIControl/STATE_Label').set_text("S: "+STATE)
	MOVIBLE.moveToDest()	

func processTravel():
	if isDead: return
	if !MOVIBLE.isMoving and STATE=="MOVE": get_input()
	
var steps=0
func onEnterTurn():
	steps=ATTRIBUTABLE.get_attr("stp")

func processTurn():
	if isDead: return
	if STATE=="MOVE":
		if steps<=0:
			Globals.turnController.finishTurn(self)
			return
		if !MOVIBLE.isMoving: 
			get_input()

func checkTileDest(tile_des):
	#print("CHECK TILE DES "+str(tile_des))
	# 1..si hay enemigo lo ataca	
	var enem=Globals.TilemapManager.get_element(tile_des,"ENEMIES")
	if enem!=null: 
		Globals.DDCORE.attack(self,enem)
		Globals.turnController.finishTurn(self)
		return false
	# 2.. si hay puerta la intenta abrir
	var cell_des=Globals.tile_map.get_cellv(tile_des)
	if cell_des==Globals.dunGen.tiles["PUERTA"]:
		set_work("OPEN",tile_des)
		return false
	# 6.. si esta la salida
	if cell_des==Globals.dunGen.tiles["SALIDA"]:
		if Globals.turnController.isTurnMode:
			Globals.effectManager.text_effect(position+Vector2(0,-50),'Debes terminar el combate')
		else: Globals.nextDungeon()
	# 3.. si hay enemigos cerca   NO ES MUY OPTIMO
	if !Globals.turnController.isTurnMode:
		var enemiGroup=Globals.TilemapManager.get_elements_in_area(tile_des,5,"ENEMIES")
		if enemiGroup.size()>0: 
			Globals.turnController.set_turn_mode()
	else:
		var enemiGroup=Globals.TilemapManager.get_elements_in_area(tile_des,7,"ENEMIES")
		#print("ENEMI GROUP AREA l108 "+str(enemiGroup))
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
		Globals.effectManager.work_effect(pos,1.5)
		yield(get_tree().create_timer(1.5), "timeout")
		if Globals.rndi(1,100)>20:
			Globals.tile_map.set_cell(pos.x,pos.y,Globals.dunGen.tiles["SUELO"])
			Globals.dunGen.DATAMAP[pos.x][pos.y]=Globals.dunGen.tiles["SUELO"]
			Globals.dunGen.showFog(pos.x,pos.y,ATTRIBUTABLE.get_attr("see"))
		else: 
			Globals.effectManager.text_effect(position,'FALLASTE')
			yield(get_tree().create_timer(0.5), "timeout")
		Globals.turnController.finishTurn(self)		
		STATE="MOVE"

func showSelectorTilePos(data):
	STATE="TILE_SELECTOR"
	var SPJ=get_node("../UIControl/SelectPj")
	SPJ.showSelector(self,data)

func dead():
	isDead=true
	visible=false
	#Globals.effectManager.grand_text_effect(Globals.player.position+Vector2(0,-150),"MUERTO")
	yield(get_tree().create_timer(3), "timeout")	
	get_tree().change_scene("res://Nodes/DeathAnimation.tscn")
	pass