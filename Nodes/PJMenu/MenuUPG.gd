extends Control

var packs=[]
var index=0
var base=0
var altar
onready var RootMenu=get_node("../")
onready var selector=$SELECTOR
onready var buttons=get_node("BUTTONS").get_children()

func _ready(): 
	randomize()
	for i in range(0, buttons.size()):
		buttons[i].get_node("icon").vframes=RootMenu.vfram
		buttons[i].get_node("icon").hframes=RootMenu.hfram
	hide()

func get_pack_desc(ind):
	var p=packs[ind]
	if p["type"]=="ATTR": 
		var TXT=p["elem"]+"+"+str(p["cnt"])
		if p.has("elem2"): TXT+="   "+p["elem2"]+"+"+str(p["cnt2"])
		return TXT
	if p["type"]=="SPL" or p["type"]=="HAB": 
		var myHab=Globals.HabsManager.getHab( p["elem"] )
		var TXT=myHab["name"]
		if p["next_cnt"]>1: TXT+=" "+Globals.DDCORE.to_roman(p["next_cnt"])
		return TXT

func show(): 
	visible=true
	$Tween.interpolate_property(self, "modulate",Color(1,1,1,0), Color(1,1,1,1), .5, $Tween.TRANS_QUAD, $Tween.EASE_OUT)
	$Tween.interpolate_property(self, "rect_position",Vector2(-80,-80), Vector2(-80,-150), .5, $Tween.TRANS_QUAD, $Tween.EASE_OUT)
	$Tween.start()
	altar=get_node("../").player.current_object_map
	packs=altar.items
	set_process(true)
	drawInfoItems()
	repos_selector()
	show_current_habs()
	#Globals.effectManager.text_effect(item.position,'Hay Items!!',0.5)
	
func hide(): 
	visible=false
	modulate=Color(1,1,1,0)
	Vector2(0,-80)
	set_process(false)

func _onAccept():
	if index+base>packs.size()-1: return
	if packs[index+base]["type"]=="NONE": return
	Globals.SoundsManager.play_sfx("UI_accept")
	altar.set_type("ALTAR_ROTO")
	upgrade(packs[index+base])
	RootMenu.exitRootMenu()	

func upgrade(p):
	if p["type"]=="ATTR":
		RootMenu.player.ATTRIBUTABLE.add_attr( p["elem"], p["cnt"] )
		if p.has("elem2"): RootMenu.player.ATTRIBUTABLE.add_attr( p["elem2"], p["cnt2"] )
	elif p["type"]=="SPL" or p["type"]=="HAB": 
		var myHab=Globals.HabsManager.getHab( p["elem"] )
		RootMenu.player.ABILITYABLE.add_base_hab( p["elem"], 1 )

func _onCancel(): 
	hide()
	RootMenu.exitRootMenu()

func _onNext(): 	
	if index<buttons.size()-1: 
		index+=1
		repos_selector()
		show_current_habs()
	elif index+base<packs.size()-1: 
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
	get_node("counter").set_text(str(index+base+1)+" / "+str(packs.size()))

func drawInfoItems():
	for i in range(0, buttons.size()):
		if i+base<packs.size():
			if packs[i+base]["type"]=="ATTR": buttons[i].get_node("icon").set_frame(31)
			elif packs[i+base]["type"]=="HAB": buttons[i].get_node("icon").set_frame(32)
			elif packs[i+base]["type"]=="SPL": buttons[i].get_node("icon").set_frame(33)
			buttons[i].get_node("name").set_text(get_pack_desc(i+base))
		else:
			buttons[i].get_node("icon").set_frame(0)
			buttons[i].get_node("name").set_text("")
	get_node("counter").set_text(str(index+base+1)+" / "+str(packs.size()))

func show_current_habs():
	var TXT=""
	if index+base<packs.size():
		if packs[index+base]["type"]=="SPL" or packs[index+base]["type"]=="HAB": 
			var realHab=Globals.HabsManager.getHab(packs[index+base]["elem"])
			TXT+=realHab["name"]+": "+realHab["desc"]
	$habs.set_text(TXT)
	$habs.rect_position.y=selector.rect_position.y

func _process(delta): #inputs.. que se desactivan y activan en onShow onHide
	if Input.is_action_just_released('ui_accept'): _onAccept()
	if Input.is_action_just_pressed('ui_cancel'): _onCancel()
	if Input.is_action_just_pressed('ui_down'): _onNext()
	if Input.is_action_just_pressed('ui_up'): _onPrev()



