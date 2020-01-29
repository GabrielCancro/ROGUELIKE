extends Control

#esto deberia venir del player

var nameAttr={}
var index=0
var base=0
onready var RootMenu=get_node("../")
onready var selector=$SELECTOR
onready var buttons=get_node("BUTTONS").get_children()

func _ready(): 
	hide()

func show(): 
	visible=true
	set_process(true)
	nameAttr = get_node("../").player.ATTRIBUTABLE.nameAttr
	drawInfoItems()
	repos_selector()
	
func hide(): 
	visible=false
	set_process(false)

func _onAccept():
	drawInfoItems()

func _onCancel(): 
	RootMenu.selectSubMenu("MenuP")

func _onNext(): 	
	if index<buttons.size()-1: 
		index+=1
		repos_selector()
	elif index+base<nameAttr.size()-1: 
		base+=1
		drawInfoItems()
		repos_selector()

func _onPrev(): 
	if index>0: 
		index-=1
		repos_selector()
	elif base>0: 
		base-=1
		drawInfoItems()
		repos_selector()

func repos_selector(): #reposiciona el selector sobre el boton actual
	var btn_pos=get_node("BUTTONS").rect_position
	var paso=Vector2(0,buttons[0].rect_size.y)
	selector.rect_position=btn_pos+paso*index
	var attr:Label=$attr
	attr.rect_position=selector.rect_position
	attr.rect_position.x+=170
	attr.set_text(nameAttr.keys()[index+base])
	get_node("counter").set_text(str(index+base+1)+" / "+str(nameAttr.size()))

func isBtn(btn_name="NONE"): #true si el boton actual coincide con el el parametro enviado
	return buttons[index].name==btn_name

func drawInfoItems():
	var k
	for i in range(0, buttons.size()):		
		if i+base<nameAttr.size():
			k=nameAttr.keys()[i+base]
			buttons[i].get_node("name").set_text( nameAttr[k] )
			buttons[i].get_node("val").set_text( str(get_node("../").player.ATTRIBUTABLE.get_attr(k) ) )
		else:
			buttons[i].get_node("name").set_text("")
			buttons[i].get_node("val").set_text( "" )
	get_node("counter").set_text(str(index+base+1)+" / "+str(nameAttr.size()))

func _process(delta): #inputs.. que se desactivan y activan en onShow onHide
	if Input.is_action_just_pressed('ui_accept'): _onAccept()
	if Input.is_action_just_pressed('ui_cancel'): _onCancel()
	if Input.is_action_just_pressed('ui_down'): _onNext()
	if Input.is_action_just_pressed('ui_up'): _onPrev()
