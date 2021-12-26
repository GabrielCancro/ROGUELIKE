extends Node

var turnObj=null
var list=[]
var chargeList={}
var isTurnMode=false
var isPausedTurn=false
var isStopedGame=false

var rnd=RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rnd.randomize()

func set_turn_mode(isTM=true):
	if isTurnMode!=isTM:
		isTurnMode=isTM
		if(isTM): 
			clear_list()
			check_enemies_range(Globals.player.TILEABLE.get_tile_pos(),6)
			add_to_list(Globals.player)
			start_turn_of(Globals.player)
			Globals.SoundsManager.play_music("music_combat")
			Globals.effectManager.custom_text_effect(Globals.get_center_camera_pos()+Vector2(0,-100),"GIANT_EARLY","COMBATE")
		else:
			Globals.SoundsManager.play_music("music_dungeon1",true)
			Globals.effectManager.custom_text_effect(Globals.get_center_camera_pos()+Vector2(0,-100),"GIANT_EARLY","TRAVESIA")

func add_to_list(obj):
	if list.has(obj): return
	list.append(obj)
	chargeList[obj.name]=100
#	print(str(chargeList))

func clear_list():
	list.clear()
	chargeList.clear()

func remove_to_list(obj):
	list.erase(obj)
	chargeList.erase(obj.name)

func _process(delta):
	if isStopedGame: return
	if isTurnMode: processTurn()
	else: processTravel()

func show_list():
	Globals.GUI.get_node("turn_label").text=str(chargeList)

func processTravel():
	if turnObj==null: 
		turnObj=Globals.player
		Globals.camera.setTarget(turnObj)
	turnObj.processTravel()

func processTurn():
	if isPausedTurn: return
	if turnObj!=null: turnObj.processTurn()
	else:
		var myTurn=null
		while turnObj==null:
			for trj in list:
				chargeList[trj.name]+=20
				
				if(chargeList[trj.name]>100): myTurn=trj
			show_list()
			if myTurn!=null: start_turn_of(myTurn)

func start_turn_of(trj):
#	show_list()
	chargeList[trj.name]-=100
	turnObj=trj
	Globals.GUI.get_node('Label_TurnOf').set_text('Turno de '+turnObj.visual_name)
	Globals.effectManager.titilar(turnObj)
	Globals.camera.setTarget(turnObj)
	turnObj.onEnterTurn()
	delay_time(.5)

func finishTurn(turneableObject):
	if turneableObject==turnObj:
		if turnObj.has_method("onFinishTurn"): turnObj.onFinishTurn()
		turnObj=null
		delay_time(.5)

func set_stoped_game(isStoped=true):
	isStopedGame=isStoped

func pauseTurn(): 
	isPausedTurn=true

func resumeTurn():
	isPausedTurn=false

func delay_time(seg):
	pauseTurn()
	yield(get_tree().create_timer(seg), "timeout")
	resumeTurn()

func check_enemies_range(pos,ran):
	print("check_enemies_range "+str(ran))
	var enemiGroup=Globals.TilemapManager.get_elements_in_area(pos,ran,"ENEMIES")
	if enemiGroup.size()==0: return
	for enemigo in enemiGroup:
		if enemy_is_alcanzable(enemigo,ran+3):
			add_to_list(enemigo)
			return true
	return false

func enemy_is_alcanzable(EN,MAX_STEPS):
	EN.calculate_path()
	return ( EN.path.size()>0 and EN.path.size()<floor(MAX_STEPS) )
