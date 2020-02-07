extends Node

var turnObj=null
var list=[]
var chargeList={}
var isTurnMode=false
var isPausedTurn=false
var i

var rnd=RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rnd.randomize()

func set_turn_mode(isTM=true):
	if isTurnMode!=isTM:
		isTurnMode=isTM
		if(isTM): 
			Globals.playMusic("music_combat")
			Globals.effectManager.text_effect(Globals.player.position+Vector2(-200,-100),'! COMBATE !')
			Globals.effectManager.text_effect(Globals.player.position+Vector2( 200, -100),'! COMBATE !')
		else: 
			Globals.playMusic("music_dungeon1")
			Globals.effectManager.text_effect(Globals.player.position+Vector2(0,-100),'-MODO TRAVESIA-')

func add_to_list(obj):
	list.append(obj)
	chargeList[obj.name]=0
	
func remove_to_list(obj):
	list.erase(obj)
	chargeList.erase(obj.name)

var pretime=0
func _process(delta):
	if isTurnMode: processTurn()
	else: processTravel()

func processTravel():
	Globals.camera.setTarget(Globals.player)
	Globals.player.processTravel()

func processTurn():
	if isPausedTurn: return
	if turnObj==null:
		if pretime>0:
			pretime-=1
			return
		for trj in list:
			if trj.TILEABLE.get_tile_pos().distance_to(Globals.player.TILEABLE.get_tile_pos())>7: continue
			chargeList[trj.name]+=5
			if(chargeList[trj.name]>100):
				chargeList[trj.name]-=100				
				turnObj=trj
				i=0
				break
	else:
		Globals.GUI.get_node('Label_TurnOf').set_text('turno de '+turnObj.name)
		if pretime==20 and turnObj.has_method("onEnterTurn"): 
			Globals.effectManager.titilar(turnObj)
			Globals.camera.setTarget(turnObj)
			turnObj.onEnterTurn()
		if pretime>30:
			turnObj.processTurn()
		else: pretime+=1

func finishTurn(turneableObject):
	if turneableObject==turnObj:
		turnObj=null

func pauseTurn(): 
	isPausedTurn=true

func resumeTurn():
	isPausedTurn=false