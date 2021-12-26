extends Node2D

onready var TILEABLE = preload('res://Class/Tileable.gd').new(self)
onready var MOVIBLE = preload('res://Class/Movible.gd').new(self)
onready var ATTRIBUTABLE = preload('res://Class/Attributable.gd').new(self)
onready var ABILITYABLE = preload('res://Class/Abilityable.gd').new(self)
onready var INVENTARIABLE = preload('res://Class/Inventariable.gd').new(self)
onready var STATEABLE = preload('res://Class/Stateable.gd').new(self)


var speed = 20
var STATE=""
var isDead=false
var current_object_map
var visual_name="Aventurero"

onready var nav_2D:Navigation2D=get_node("../Nav2D")
onready var menu=get_node("../RootMenu")

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.TurnController.add_to_list(self)	
	yield(get_tree().create_timer(0.2), "timeout")	
	ATTRIBUTABLE.set_attr("hp",7)#max hp
	ATTRIBUTABLE.set_attr("pp",2)
	ATTRIBUTABLE.set_attr("atk",2)
	ATTRIBUTABLE.set_attr("def",1)
	ATTRIBUTABLE.set_attr("dan",1)
	ATTRIBUTABLE.set_attr("stp",5)
	
	ATTRIBUTABLE.set_attr(".hp",ATTRIBUTABLE.get_attr("hp"))
	ATTRIBUTABLE.set_attr(".pp",ATTRIBUTABLE.get_attr("pp"))
	ATTRIBUTABLE.set_attr(".stp",ATTRIBUTABLE.get_attr("stp"))

#	STATEABLE.add_state("INMOVILIZADO",2)
#	STATEABLE.add_state("ENVENENADO",3)
#	ABILITYABLE.set_base_hab("BERSERK",1)
#	ABILITYABLE.set_base_hab("VENENOSO",1)
#	ABILITYABLE.set_base_hab("OJOMAGICO",1)
#	ABILITYABLE.set_base_hab("PUNTERIA",3)
#	ABILITYABLE.set_base_hab("ARQUERIA",1)
#	ABILITYABLE.set_base_hab("IMPACTO",2)
#	ABILITYABLE.set_base_hab("DEBILITAR",1)
#	ABILITYABLE.set_base_hab("EXPLOSION",2)
#
#	INVENTARIABLE.addItem(121,2)
#	INVENTARIABLE.addItem(122,2)
#	INVENTARIABLE.addItem(123,2)

	if Globals.OPTIONS.DATA_SAVE["encurso"]==true: Globals.OPTIONS.load_player_data()
	Globals.GUI.updateGUI()
	Globals.nextDungeon()
	STATE="MOVE"

func get_input():
	if Globals.CONTROL_INPUT!="PLAYER": return
	var v = Vector2(0,0)
	if Input.is_action_pressed('ui_right'): v.x += 1
	elif Input.is_action_pressed('ui_left'): v.x -= 1
	elif Input.is_action_pressed('ui_down'): v.y += 1
	elif Input.is_action_pressed('ui_up'): v.y -= 1	
	##if moveToPath: movePath()
	##elif v.x!=0 || v.y!=0:
	if v.x!=0 || v.y!=0:
		var myTileDes=TILEABLE.get_tile_pos()+v
		var chkDest=checkTileDest(myTileDes)
		print("CHECK? "+str(chkDest) )
		if chkDest: MOVIBLE.set_tile_des(myTileDes)

	if Input.is_action_just_released('ui_accept'): 
			setState("MENU")
			menu.showRootMenu(self)
	if Input.is_action_just_released('ui_cancel'): 
		#ATTRIBUTABLE.print_all_attr()
		#ABILITYABLE.print_all_habs()
		pass
	if Input.is_action_just_released('ui_select'): 
		pass
		#Globals.dunGen.generateDungeon(Globals.tile_map)
#	if Input.is_action_just_released('toggle_mode'):
#		Globals.effectManager.sheet_fx("EXPLODE",position+Vector2(32,32))
#		STATEABLE.add_state("INMOVILIZADO",3)
#		Globals.DialogsManager.diag("un texto de texto un texto de texto un texto de texto un texto de texto un texto de texto")

func setState(_state):
	yield(get_tree().create_timer(0.1), "timeout")
	STATE=_state

func on_exit_menu(data):
	yield(get_tree().create_timer(.2), "timeout")
	if data["action"]=="NONE": 
		setState("MOVE")
	elif data["action"]=="CAST":
		showSelectorTilePos(data)
	elif data["action"]=="HAB":
		Globals.HabsManager.ejecutarHab(self,data)
	elif data["action"]=="SPL":
		Globals.HabsManager.ejecutarSpell(self,data)

func on_exit_selector(data):
	#print("on_exit_selector: "+str(data))
	if data.has("tilePos"):
		if data.has("action"):
			if data["action"]=="HAB": Globals.HabsManager.ejecutarHabInPos(self,data)
			elif data["action"]=="SPL": Globals.HabsManager.ejecutarSpellInPos(self,data)
	else: 
		yield(get_tree().create_timer(.5), "timeout")
		setState("MOVE")

func processTravel():
	if isDead: return
	if !MOVIBLE.isMoving and STATE=="MOVE": get_input()
	
func onEnterTurn():
	ATTRIBUTABLE.set_attr( ".stp", ATTRIBUTABLE.get_attr("stp") )

func processTurn():
	if isDead: return
	if STATE=="MOVE":
		if ATTRIBUTABLE.get_attr(".stp")<=0:
			Globals.turnController.finishTurn(self)
			return
		if !MOVIBLE.isMoving: 
			get_input()

func onFinishTurn():
	STATEABLE.update_all_states()
	Globals.GUI.updateGUI()
	#Globals.effectManager.custom_text_effect(position+Vector2(0,-10),"STEPS","..")

func checkTileDest(tile_des=TILEABLE.get_tile_pos()):
	#print("CHECK TILE DES "+str(tile_des))
	#OBTENEMOS EL TIPO DE CASILLERO DEL DESTINO
	var own_pos = TILEABLE.get_tile_pos()
	if tile_des.x!=own_pos.x: get_node( "Sprite" ).set_flip_h( tile_des.x<own_pos.x )
	var cell_des=Globals.tile_map.get_cellv(tile_des)
	if Globals.dunGen.traversablesIndexs.has(cell_des):
		ATTRIBUTABLE.add_attr(".stp",-1)
	
	# 1..si hay enemigo lo ataca
	var enem=Globals.TilemapManager.get_element(tile_des,"ENEMIES")
	if enem!=null: 
		Globals.AttackManager.attack("MELEE",[self,enem])
#		Globals.DDCORE.attack(self,enem)
		Globals.turnController.finishTurn(self)
		return false	
	
	# si hay puerta la intenta abrir
	if cell_des==Globals.dunGen.tiles["PUERTA"]:
		set_work("OPEN",tile_des)
		return false
	#si es un casillero no caminable retorna false
	if !Globals.dunGen.traversablesIndexs.has(cell_des): 
		return
	# 6.. si esta la salida
	if cell_des==Globals.dunGen.tiles["SALIDA"]:
		if Globals.turnController.isTurnMode:
			Globals.effectManager.text_effect(position+Vector2(0,-50),'Debes terminar el combate')
		else: 
			setState("MENU")
			menu.showRootMenu(self,"Menu_prg_NEXTLEVEL")
			
	#EN COMBATE
	if Globals.turnController.isTurnMode:  
		if !Globals.TurnController.check_enemies_range(tile_des,6): # SI NO HAY ENEMIGOS EN EL RANGO
			Globals.turnController.set_turn_mode(false)
		if ATTRIBUTABLE.get_attr(".stp")>=0: Globals.effectManager.custom_text_effect(position,"STEPS",str( ATTRIBUTABLE.get_attr(".stp") ))
	else: #EN TRAVESIA
		if Globals.TurnController.check_enemies_range(tile_des,5): # SI HAY ENEMIGOS EN EL RANGO
			Globals.turnController.set_turn_mode(true)
		if ATTRIBUTABLE.get_attr(".stp")<=0: 
			Globals.turnController.finishTurn(self)
			onEnterTurn()
	# 4.. si hay un items
	current_object_map=Globals.TilemapManager.get_element(tile_des,"OBJECTS")
	if current_object_map!=null: 
		current_object_map.on_activate(self)
	
	#EXPLORAMOS
	Globals.dunGen.showFog(tile_des.x,tile_des.y,ATTRIBUTABLE.get_attr("see"))
	return true


func set_work(name,tile_pos):
	STATE="WORK"
	ATTRIBUTABLE.set_attr(".stp",0)
	if(name=="OPEN"):
		Globals.SoundsManager.play_sfx("Lockpick_start")
		Globals.effectManager.sheet_fx( "WORK",Globals.to_wpos(tile_pos) )
		yield(get_tree().create_timer(1.2), "timeout")
		var rnd100=Globals.rndi(1,100)
		Globals.GUI.add_info_concat("Abrir cerradura   75%")
		if rnd100<75:
			Globals.SoundsManager.play_sfx("Lockpick_win")
			Globals.tile_map.set_cell(tile_pos.x,tile_pos.y,Globals.dunGen.tiles["SUELO"])
			Globals.dunGen.DATAMAP[tile_pos.x][tile_pos.y]=Globals.dunGen.tiles["SUELO"]
			Globals.dunGen.showFog(tile_pos.x,tile_pos.y,ATTRIBUTABLE.get_attr("see"))
			checkTileDest( TILEABLE.get_tile_pos() )
			Globals.add_score(2)
			Globals.GUI.add_info_concat("   EXITO")
		else: 
			Globals.effectManager.text_effect(position,'FALLASTE')
			Globals.SoundsManager.play_sfx("Lockpick_fail")
			Globals.GUI.add_info_concat("   FALLO")
			yield(get_tree().create_timer(0.5), "timeout")
		Globals.turnController.finishTurn(self)
		Globals.GUI.add_info_line()
		STATE="MOVE"

func showSelectorTilePos(data):
	STATE="TILE_SELECTOR"
	var SPJ=get_node("../SelectPj")
	SPJ.showSelector(self,data)

func dead():
	isDead=true
	visible=false
	Globals.OPTIONS.DATA_SAVE["encurso"]=false
	Globals.OPTIONS.save_options()
	#Globals.effectManager.grand_text_effect(Globals.player.position+Vector2(0,-150),"MUERTO")
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene_to( load("res://0Scenes/DeadScene/DeadScene.tscn") )
	pass
