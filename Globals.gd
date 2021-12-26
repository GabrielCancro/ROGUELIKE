extends Node

# gc globals methods

var tile_map:TileMap
var fog_map:TileMap
var nav:Navigation2D
var camera:Camera2D
var GUI
var dunGen
var turnController
var effectManager
var tile_size
var player
var ASTAR = preload('res://Game/UTILS/ASTAR.gd').new()
var DDCORE = preload('res://Game/UTILS/DDCORE.gd').new()
var OPTIONS = preload('res://Options.gd').new()
var TurnController
var Cinematic
var AndroidUI
var TilemapManager
var ItemsManager
var HabsManager
var EnemiesManager
var SoundsManager
var DialogsManager
var AttackManager
var rnd = RandomNumberGenerator.new()

var BTNS=["X","Z"]
var CONTROL_INPUT="PLAYER"

func _ready():
	rnd.randomize()

func _initGlobals():
	print("EJECUTAMOS init Globals !!!!!")
	tile_map=get_node("/root/Node2D/Nav2D/TileMap")
	fog_map=get_node("/root/Node2D/Nav2D/FogMap")
	nav=get_node("/root/Node2D/Nav2D")
	camera=get_node("/root/Node2D/Camera2D")
	GUI=get_node("/root/Node2D/UIControl")
	dunGen=get_node("/root/Node2D/DungeonGenerator")
	turnController=get_node("/root/Node2D/TurnController")
	effectManager=get_node("/root/Node2D/EffectManager")
	tile_size=tile_map.cell_size
	player=get_node("/root/Node2D/Player")
	TurnController = get_node("/root/Node2D/TurnController")
	Cinematic  = get_node("/root/Node2D/Cinematic")
	AndroidUI  = get_node("/root/Node2D/AndroidUI")
	TilemapManager = get_node("/root/Node2D/TilemapManager")
	ItemsManager = get_node("/root/Node2D/ItemsManager")
	HabsManager = get_node("/root/Node2D/HabsManager")
	EnemiesManager = get_node("/root/Node2D/EnemiesManager")
	SoundsManager = get_node("/root/Node2D/SoundsManager")
	DialogsManager = get_node("/root/Node2D/UIControl/DialogsManager")
	AttackManager = get_node("/root/Node2D/AttackManager")
	#get_tree().change_scene("res://Nodes/menuPrincipal/menu_principal.tscn")
	pass

func rndi(minim,maxim):
	return rnd.randi_range(minim, maxim)

func nextDungeon():
	dunGen.NIVEL+=1
	if dunGen.NIVEL>1: 
		Globals.OPTIONS.save_player_data()
		Globals.OPTIONS.DATA_SAVE["encurso"]=true
		Globals.OPTIONS.save_options()
	Cinematic.show_black()
	yield(get_tree().create_timer(.01), "timeout")
	if dunGen.NIVEL==1: 
		dunGen.generateDungeon("TUTORIAL")
		GUI.get_node("button_skip_tuto").visible=true
	else: dunGen.generateDungeon("PROCEDURAL")
#	print(str(dunGen.NIVEL))
	#if dunGen.NIVEL==1: Cinematic.start_cinematic("CINE_END")
	#if dunGen.NIVEL==10: Cinematic.start_cinematic("CINE_INTRO")
	set_tileset(dunGen.NIVEL)
	GUI.update_labal_level(dunGen.NIVEL)
	yield(get_tree().create_timer(.1), "timeout")
	#print(str(pos_ini))	
	player.TILEABLE.set_tile_pos(dunGen.POS_INI)
	player.checkTileDest(dunGen.POS_INI)
	dunGen.showFog(dunGen.POS_INI.x,dunGen.POS_INI.y,player.ATTRIBUTABLE.get_attr("see"))	
	if dunGen.NIVEL==1: Cinematic.start_cinematic("CINE_INTRO")
	if dunGen.NIVEL==16:
		Globals.OPTIONS.DATA_SAVE["encurso"]=false
		Globals.OPTIONS.save_options()
		Cinematic.start_cinematic("CINE_END")
	yield(get_tree().create_timer(.5), "timeout")
	Cinematic.hide_black()
	yield(get_tree().create_timer(.1), "timeout")
	effectManager.custom_text_effect(player.position+Vector2(0,-100),"GIANT","NIVEL "+str(dunGen.NIVEL))

func add_score(cnt):
	Globals.OPTIONS.DATA_SAVE["score"]+=cnt
	GUI.updateGUI()

func set_CONTROL_INPUT(ctr):
	CONTROL_INPUT=ctr

func get_center_camera_pos():
	return camera.position

func set_tileset(lvl):
	if lvl<=3: tile_map.tile_set.tile_set_texture(0,preload("res://sprites/tilesMap/auto_wall_dungeon.png"))
	elif lvl<=6: tile_map.tile_set.tile_set_texture(0,preload("res://sprites/tilesMap/auto_wall_cave.png"))
	elif lvl<=8: tile_map.tile_set.tile_set_texture(0,preload("res://sprites/tilesMap/auto_wall_rock.png"))
	elif lvl<=10: tile_map.tile_set.tile_set_texture(0,preload("res://sprites/tilesMap/auto_wall_castle.png"))

func to_wpos(tpos): return tile_map.map_to_world(tpos)+tile_size/2
