extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ini=true
onready var MOVIBLE = preload('res://Class/Movible.gd').new(self)
var speed=20
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.TurnController.add_to_list(self)
	pass # Replace with function body.

func _process(delta):
	MOVIBLE.moveToDest()
	pass

func getTilePos():
	return Globals.tile_map.world_to_map(position)

func set_tilePosition(px,py):
	set_position(Vector2(px,py)*Globals.tile_size+Globals.tile_size/2)
	print("ENEMY-"+str(position)+"  "+str(px)+","+str(py))

var path
var pathIndex
var steps
func onEnterTurn():	
	path=Globals.ASTAR.get_astar_path(getTilePos(),Globals.player.getTilePos())
	pathIndex=0
	steps=5
	if path==null: path=[getTilePos()]
	if(path.size()>1):
		MOVIBLE.set_tile_des(path[0])
		Globals.nav.drawPath(path)

func processTurn():
	if !MOVIBLE.isMoving:
		pathIndex+=1
		steps-=1
		if(pathIndex==path.size()-1):
			Globals.effectManager.text_effect(position,'ATTACK',1)
			Globals.DDCORE.attack(self,Globals.player)
			Globals.turnController.finishTurn(self)
			return			
		elif(steps<0):
			Globals.turnController.finishTurn(self)
			return
		elif(path.size()-1<pathIndex):
			Globals.turnController.finishTurn(self)
			return
		else: 
			Globals.effectManager.text_effect(position,':'+str(steps),1)
			MOVIBLE.set_tile_des(path[pathIndex])

func processTravel():
	pass

#func set_path(value: PoolVector2Array)->void:
#	path=value
#	moveToPath=true
#	indexPath=0
#
#func movePath():	
#	if path.size()<=0: return
#	var start_point: = position
#	var next_point: = path[indexPath]
#	var distance_to_next: = start_point.distance_to(next_point)
#	if distance_to_next>5.0:
#		var direction = ( next_point - start_point ).normalized()
#		velocity=direction*speed
#	else:
#		indexPath+=1
#		#position=next_point
#		velocity=Vector2(0,0)
#	#print(str(distance_to_next)+"-"+str(velocity.x)+","+str(velocity.y))
#	if indexPath>=path.size():
#		moveToPath=false