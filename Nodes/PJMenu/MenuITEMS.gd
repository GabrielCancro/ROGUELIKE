extends Control

var items=[]
var index=0
var base=0
onready var RootMenu=get_node("../")
onready var selector=$SELECTOR
onready var buttons=get_node("BUTTONS").get_children()

func _ready(): 
	hide()

func show(): 
	print("SHOW!!!")
	visible=true
	$Tween.interpolate_property(self, "modulate",Color(1,1,1,0), Color(1,1,1,1), .5, $Tween.TRANS_QUAD, $Tween.EASE_OUT)
	$Tween.interpolate_property(self, "rect_position",Vector2(-80,-80), Vector2(-80,-150), .5, $Tween.TRANS_QUAD, $Tween.EASE_OUT)
	$Tween.start()
	set_process(true)
	#items = get_node("../").player.data.items
	items=get_node("../").player.currentBag.items
	drawInfoItems()
	repos_selector()
	#Globals.effectManager.text_effect(item.position,'Hay Items!!',0.5)
	
func hide(): 
	visible=false
	modulate=Color(1,1,1,0)
	Vector2(0,-80)
	set_process(false)

func _onAccept():
	if index+base>items.size()-1: return
	get_node("../").player.INVENTARIABLE.addItem( items[index+base].get("code") )
	if items[index+base].get("cnt",0)>1: items[index+base]["cnt"]-=1
	else: items.remove(index+base) 	
	drawInfoItems()

func _onCancel(): 
	hide()
	RootMenu.exitRootMenu()

func _onNext(): 	
	if index<buttons.size()-1: 
		index+=1
		repos_selector()
	elif index+base<items.size()-1: 
		base+=1
		drawInfoItems()

func _onPrev(): 
	if index>0: 
		index-=1
		repos_selector()
	elif base>0: 
		base-=1
		drawInfoItems()

func repos_selector(): #reposiciona el selector sobre el boton actual
	var btn_pos=get_node("BUTTONS").rect_position
	var paso=Vector2(0,buttons[0].rect_size.y)
	selector.rect_position=btn_pos+paso*index
	get_node("counter").set_text(str(index+base+1)+" / "+str(items.size()))

func isBtn(btn_name="NONE"): #true si el boton actual coincide con el el parametro enviado
	return buttons[index].name==btn_name

func drawInfoItems():
	for i in range(0, buttons.size()):
		if i+base<items.size():
			buttons[i].get_node("icon").set_frame(items[i+base]["icon"])
			buttons[i].get_node("name").set_text(items[i+base]["name"])
			buttons[i].get_node("desc").set_text(Globals.ItemsManager.build_description(items[i+base]))
			if items[i+base].get("cnt",0)>0: buttons[i].get_node("cnt").set_text("x"+str(items[i+base].get("cnt",0)) )
			else: buttons[i].get_node("cnt").set_text("")
		else:
			buttons[i].get_node("icon").set_frame(11)
			buttons[i].get_node("name").set_text("")
			buttons[i].get_node("desc").set_text("---")
			buttons[i].get_node("cnt").set_text("")
	get_node("counter").set_text(str(index+base+1)+" / "+str(items.size()))

func _process(delta): #inputs.. que se desactivan y activan en onShow onHide
	if Input.is_action_just_pressed('ui_accept'): _onAccept()
	if Input.is_action_just_pressed('ui_cancel'): _onCancel()
	if Input.is_action_just_pressed('ui_down'): _onNext()
	if Input.is_action_just_pressed('ui_up'): _onPrev()



