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

func add_to_list(obj):
	list.append(obj)
	chargeList[obj.name]=0

var pretime=0
func _process(delta):
	if isTurnMode: processTurn()
	else: processTravel()

func processTravel():
	Globals.camera.setTarget(Globals.player)
	for trj in list:
		trj.processTravel()

func processTurn():
	if isPausedTurn: return
	if turnObj==null:
		if pretime>0:
			pretime-=1
			return
		for trj in list:
			chargeList[trj.name]+=rnd.randi_range(1,5)
			if(chargeList[trj.name]>100):
				chargeList[trj.name]-=100				
				turnObj=trj
				i=0
				print("is turn of "+turnObj.name)
				break
	else:
		Globals.GUI.get_node('Label_TurnOf').set_text('turno de '+turnObj.name)
		if pretime==20 and turnObj.has_method("onEnterTurn"): 
			turnObj.onEnterTurn()
		if pretime>20:
			if Globals.fog_map.get_cellv(turnObj.getTilePos())==-1: Globals.camera.setTarget(turnObj)
			turnObj.processTurn()			
		else: pretime+=1

func finishTurn(turneableObject):
	if turneableObject==turnObj:
		turnObj=null

func pauseTurn(): 
	isPausedTurn=true

func resumeTurn():
	isPausedTurn=false