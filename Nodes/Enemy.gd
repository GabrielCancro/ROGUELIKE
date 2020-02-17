extends Node2D

var ini=true
var speed=20
var visual_name="Enemy"

onready var TILEABLE = preload('res://Class/Tileable.gd').new(self,"ENEMIES")
onready var MOVIBLE = preload('res://Class/Movible.gd').new(self)
onready var ATTRIBUTABLE = preload('res://Class/Attributable.gd').new(self)

func _ready():
	Globals.TurnController.add_to_list(self)
	pass # Replace with function body.

func _process(delta):	
	MOVIBLE.moveToDest()

func dead():
	Globals.TurnController.remove_to_list(self)
	Globals.TilemapManager.remove_to_tilegroup(self,"ENEMIES")
	queue_free()

var path
var pathIndex
var steps
func onEnterTurn():
	steps=ATTRIBUTABLE.get_attr("stp")
	calculate_path()
	if path==null: path=[TILEABLE.get_tile_pos()]
	if(path.size()>1): MOVIBLE.set_tile_des(path[0])

func calculate_path():
	var pos_ASTAR=TILEABLE.get_tile_pos()+(Globals.player.TILEABLE.get_tile_pos()-TILEABLE.get_tile_pos())/2
	pos_ASTAR=Vector2(floor(pos_ASTAR.x),floor(pos_ASTAR.y))
	var ran_ASTAR=8
	var obst_grid=Globals.TilemapManager.get_obstacles_in_area(pos_ASTAR,ran_ASTAR)
	obst_grid[TILEABLE.get_tile_pos().x-pos_ASTAR.x+ran_ASTAR][TILEABLE.get_tile_pos().y-pos_ASTAR.y+ran_ASTAR]=0
	Globals.ASTAR.setAstarRect(pos_ASTAR,ran_ASTAR,Globals.dunGen.DATAMAP,obst_grid)
	path=Globals.ASTAR.get_astar_path(TILEABLE.get_tile_pos(),Globals.player.TILEABLE.get_tile_pos())
	pathIndex=0
	return path

func processTurn():
	if !MOVIBLE.isMoving:
		pathIndex+=1
		steps-=1
		if path.size()<=1: 
			Globals.turnController.finishTurn(self)
			return
		if(steps<0):
			Globals.turnController.finishTurn(self)
			return
		if(pathIndex==path.size()-1):
			#Globals.effectManager.text_effect(position,'ATTACK')
			Globals.DDCORE.attack(self,Globals.player)
			get_node( "Sprite" ).set_flip_h( Globals.player.TILEABLE.get_tile_pos().x<TILEABLE.get_tile_pos().x )
			Globals.turnController.finishTurn(self)
			return			
		else: 
			Globals.effectManager.custom_text_effect(position,"STEPS",str(steps))
			MOVIBLE.set_tile_des(path[pathIndex])