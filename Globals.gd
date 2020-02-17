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
var ASTAR = preload('res://Nodes/UTILS/ASTAR.gd').new()
var DDCORE = preload('res://Nodes/UTILS/DDCORE.gd').new()
var TurnController
var TilemapManager
var ItemsManager
var HabsManager
var EnemiesManager
var SoundsManager
var rnd = RandomNumberGenerator.new()

func _ready():
	rnd.randomize()

func _initGlobals():
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
	TilemapManager = get_node("/root/Node2D/TilemapManager")
	ItemsManager = get_node("/root/Node2D/ItemsManager")
	HabsManager = get_node("/root/Node2D/HabsManager")
	EnemiesManager = get_node("/root/Node2D/EnemiesManager")
	SoundsManager = get_node("/root/Node2D/SoundsManager")
	
	#get_tree().change_scene("res://Nodes/menuPrincipal/menu_principal.tscn")
	pass

func rndi(minim,maxim):
	return rnd.randi_range(minim, maxim)

func nextDungeon():
	yield(get_tree().create_timer(.1), "timeout")
	var pos_ini=Globals.dunGen.generateDungeon(Globals.tile_map)
	yield(get_tree().create_timer(.1), "timeout")
	print(str(pos_ini))	
	player.TILEABLE.set_tile_pos(pos_ini)
	player.checkTileDest(pos_ini)
	dunGen.showFog(pos_ini.x,pos_ini.y,player.ATTRIBUTABLE.get_attr("see"))
	yield(get_tree().create_timer(.5), "timeout")
	effectManager.custom_text_effect(player.position+Vector2(0,-100),"GIANT","NIVEL "+str(dunGen.NIVEL))

func get_center_camera_pos():
	return camera.position

func load_death_scene():	
	# Remove the current level
	var ROOT=get_node("/root")
	var old_scn=get_node("/root/Node2D")
	ROOT.remove_child( old_scn )
	old_scn.call_deferred("free")
	
	get_tree().change_scene_to( load("res://Nodes/DeathAnimation.tscn") )
## Add the next level
#var next_level_resource = load("res://path/to/scene.tscn)
#var next_level = next_level_resource.instance()
#root.add_child(next_level)