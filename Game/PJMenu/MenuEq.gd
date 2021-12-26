extends Control

#esto deberia venir del player

var items=[]
var index=0
var base=0
onready var RootMenu=get_node("../")
onready var selector=$SELECTOR
onready var buttons=get_node("BUTTONS").get_children()

func _ready(): 
	$left_to_drop.text="[LEFT]+["+Globals.BTNS[0]+"] to destroy item"
	for i in range(0, buttons.size()):
		buttons[i].get_node("icon").vframes=RootMenu.vfram
		buttons[i].get_node("icon").hframes=RootMenu.hfram
	hide()

func show(): 
	visible=true
	set_process(true)
	items = get_node("../").player.INVENTARIABLE.equip
	drawInfoItems()
	repos_selector()
	show_current_habs()
	
func hide(): 
	visible=false
	set_process(false)

func _onAccept():
	if items.size()-1<index+base: return
	Globals.SoundsManager.play_sfx("UI_accept")
	var ITEM=items[index+base]
	if ITEM.get("eq","")=="":
		for i in range(0, items.size()):
			if items[i]["type"]==ITEM["type"]: items[i].erase("eq") 
		ITEM["eq"]="EQ"
	else: ITEM.erase("eq") 
	get_node("../").player.INVENTARIABLE.change_equipament()
	drawInfoItems()

func _onDrop():
	if items.size()-1<index+base: return
	Globals.SoundsManager.play_sfx("UI_accept")
	items.erase(items[index+base])
	get_node("../").player.INVENTARIABLE.change_equipament()
	drawInfoItems()
	repos_selector()
	show_current_habs()

func _onCancel(): 
	RootMenu.selectSubMenu("MenuP")

func _onNext(): 	
	if index<buttons.size()-1: 
		index+=1
		repos_selector()
		show_current_habs()
	elif index+base<items.size()-1: 
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
	get_node("counter").set_text(str(index+base+1)+" / "+str(items.size()))
	
func show_current_habs():
	var TXT=""
	if index+base<items.size():
		var code_hab=items[index+base].get("code_hab_1",null)
		if code_hab: 
			var realHab=Globals.HabsManager.getHab(code_hab)
			var cnt=int(items[index+base].get("cnt_hab_1",0))
			TXT+=realHab["name"]+" "+Globals.DDCORE.to_roman(cnt)+": "+Globals.HabsManager.getDesc(code_hab,cnt)
		code_hab=items[index+base].get("code_hab_2",null)
		if code_hab: 
			var realHab=Globals.HabsManager.getHab(code_hab)
			var cnt=int(items[index+base].get("cnt_hab_2",0))
			TXT+="\n"+realHab["name"]+" "+Globals.DDCORE.to_roman(cnt)+": "+Globals.HabsManager.getDesc(code_hab,cnt)
	$habs.set_text(TXT)
	$habs.rect_position.y=selector.rect_position.y
 

func isBtn(btn_name="NONE"): #true si el boton actual coincide con el el parametro enviado
	return buttons[index].name==btn_name

func drawInfoItems():
	for i in range(0, buttons.size()):
		if i+base<items.size():
			buttons[i].get_node("icon").set_frame(items[i+base]["icon"])
			buttons[i].get_node("name").set_text(items[i+base]["name"])
			
			buttons[i].get_node("desc").set_text( Globals.ItemsManager.build_description(items[i+base]) )
			var eq=items[i+base].get("eq","")
			if eq!="": eq=items[i+base].get("type","")
			buttons[i].get_node("eq").set_text(eq)
		else:
			buttons[i].get_node("icon").set_frame(0)
			buttons[i].get_node("name").set_text("")
			buttons[i].get_node("desc").set_text("---")
			buttons[i].get_node("eq").set_text("")
	get_node("counter").set_text(str(index+base+1)+" / "+str(items.size()))

func _process(delta): #inputs.. que se desactivan y activan en onShow onHide
	if Input.is_action_just_pressed('ui_cancel'): _onCancel()
	if Input.is_action_just_pressed('ui_down'): _onNext()
	if Input.is_action_just_pressed('ui_up'): _onPrev()
	if Input.is_action_pressed("ui_left"): 
		if Input.is_action_just_pressed('ui_accept'): _onDrop()
	else:
		if Input.is_action_just_pressed('ui_accept'): _onAccept()
