extends Control

#esto deberia venir del player

var habs=[]
var index=0
var base=0
onready var RootMenu=get_node("../")
onready var selector=$SELECTOR
onready var buttons=get_node("BUTTONS").get_children()

func _ready(): 
	for i in range(0, buttons.size()):
		buttons[i].get_node("icon").vframes=RootMenu.vfram
		buttons[i].get_node("icon").hframes=RootMenu.hfram
	hide()

func show(): 
	visible=true
	set_process(true)
	habs = get_node("../").player.ABILITYABLE.get_all_habs()
	drawInfoItems()
	repos_selector()
	show_current_habs()
	
func hide(): 
	visible=false
	set_process(false)

func _onAccept():
	if index+base>habs.size()-1: return
	var myHab=Globals.HabsManager.getHab( habs.keys()[index+base] )
	if(myHab["type"]=="ACT"):
		Globals.SoundsManager.play_sfx("UI_accept")
		RootMenu.exitRootMenu({"action":"HAB","hab":habs.keys()[index+base],"cnt":habs[ habs.keys()[index+base] ]})
	elif(myHab["type"]=="SPL"):
		Globals.SoundsManager.play_sfx("UI_accept")
		RootMenu.exitRootMenu({"action":"SPL","spell":habs.keys()[index+base],"cnt":habs[ habs.keys()[index+base] ]})

func _onCancel(): 
	RootMenu.selectSubMenu("MenuP")

func _onNext(): 	
	if index<buttons.size()-1: 
		index+=1
		repos_selector()
		show_current_habs()
	elif index+base<habs.size()-1: 
		base+=1
		drawInfoItems()
		show_current_habs()

func _onPrev(): 
	if index>0: 
		index-=1
		repos_selector()
		show_current_habs()
	elif base>0: 
		base-=1
		drawInfoItems()
		show_current_habs()

func repos_selector(): #reposiciona el selector sobre el boton actual
	var btn_pos=get_node("BUTTONS").rect_position
	var paso=Vector2(0,buttons[0].rect_size.y)
	selector.rect_position=btn_pos+paso*index
	get_node("counter").set_text(str(index+base+1)+" / "+str(habs.size()))
	
func show_current_habs():
	var TXT=""
	if index+base<habs.size():
		var codeCurrentHab=habs.keys()[index+base]
		TXT=Globals.HabsManager.getDesc(codeCurrentHab, habs[ codeCurrentHab ])
	$habs.set_text(TXT)
	$habs.rect_position.y=selector.rect_position.y 

func isBtn(btn_name="NONE"): #true si el boton actual coincide con el el parametro enviado
	return buttons[index].name==btn_name

func drawInfoItems():
	for i in range(0, buttons.size()):
		if i+base<habs.size():
			var myHab=Globals.HabsManager.getHab( habs.keys()[i+base] )
			var myCnt=habs[ habs.keys()[i+base] ]
			print(str(myHab)+":"+str(myCnt))
			#buttons[i].get_node("icon").set_frame( myHab["icon"] )
			if(myHab["type"]=="ACT"): buttons[i].get_node("icon").set_frame(93)
			elif(myHab["type"]=="PAS"): buttons[i].get_node("icon").set_frame(92)
			elif(myHab["type"]=="SPL"): buttons[i].get_node("icon").set_frame(91)
			var textName=myHab["name"]
			if myHab["max"]>1: textName+=" "+Globals.DDCORE.to_roman(myCnt)
			buttons[i].get_node("name").set_text( textName )
		else:
			buttons[i].get_node("icon").set_frame(0)
			buttons[i].get_node("name").set_text("")
	get_node("counter").set_text(str(index+base+1)+" / "+str(habs.size()))

func _process(delta): #inputs.. que se desactivan y activan en onShow onHide
	if Input.is_action_just_released('ui_accept'): _onAccept()
	if Input.is_action_just_pressed('ui_cancel'): _onCancel()
	if Input.is_action_just_pressed('ui_down'): _onNext()
	if Input.is_action_just_pressed('ui_up'): _onPrev()
