extends Control

var index=0
onready var RootMenu=get_node("../")
onready var selector=$SELECTOR
onready var buttons=get_node("BUTTONS").get_children()

func _ready(): print(RootMenu.name)

func show(): 
	visible=true
	set_process(true)
	repos_selector()
	
func hide(): 
	visible=false
	set_process(false)

func _onAccept(): 
	if isBtn("BTN_EQ"):
		RootMenu.selectSubMenu("MenuEq")
	elif isBtn("BTN_SPL"):
		var pj=RootMenu.getPlayer()
		pj.set_work("OPEN",pj.tilePos()+Vector2(1,0)) #crea una puerta (solo para testear)
		hide()
		#esperamos un poco para cerrar asi no coliciona el input con el de abrir el menu
		yield(get_tree().create_timer(0.2), "timeout")
		RootMenu.exitRootMenu()

func _onCancel(): 
	hide()
	RootMenu.exitRootMenu()

func _onNext(): 
	index+=1
	if index>buttons.size()-1: index=0
	repos_selector()

func _onPrev(): 
	index-=1
	if index<0: index=buttons.size()-1
	repos_selector()

func repos_selector(): #reposiciona el selector sobre el boton actual
	var btn_pos=get_node("BUTTONS").rect_position
	var paso=Vector2(buttons[0].rect_size.x,0)
	selector.rect_position=btn_pos+paso*index

func isBtn(btn_name="NONE"): #true si el boton actual coincide con el el parametro enviado
	return buttons[index].name==btn_name

func _process(delta): #inputs.. que se desactivan y activan en onShow onHide
	if Input.is_action_just_pressed('ui_accept'): _onAccept()
	if Input.is_action_just_pressed('ui_cancel'): _onCancel()
	if Input.is_action_just_pressed('ui_right'): _onNext()
	if Input.is_action_just_pressed('ui_left'): _onPrev()
