extends Node

# gc globals methods

var tile_map:TileMap
var fog_map:TileMap
var nav:Navigation2D
var camera:Camera2D
var GUI:Camera2D
var dunGen
var turnController
var effectManager
var tile_size
var player
var ASTAR = preload('res://Nodes/UTILS/ASTAR.gd').new()
var DDCORE = preload('res://Nodes/UTILS/DDCORE.gd').new()
var TurnController
var soundManager

func _ready():
	pass

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
	
	soundManager=AudioStreamPlayer.new()
	effectManager.add_child(soundManager)
	soundManager.stream=load("res://Sounds/music_dungeon1.ogg")
	soundManager.play()
	#get_tree().change_scene("res://Nodes/menuPrincipal/menu_principal.tscn")
	pass