extends Control

# Declare member variables here. Examples:
var index=0
var max_index=3
var current_menu="MenuP"
var menu_childrens
var button_size
var menu_position
var player: Node2D
onready var selector=$Selector

func _ready():
	visible=false

func _process(delta):
	if !isActive(): return
	
	cancelButton()
	acceptButton()
	
	if Input.is_action_just_pressed('ui_right'):
		index+=1
		if index>max_index: index=0
		reposition_selector()
	
	if Input.is_action_just_pressed('ui_left'):
		index-=1
		if index<0: index=max_index
		reposition_selector()
		
func reposition_selector():
	selector.rect_position=menu_position+button_size*index
	print(str(rect_position.x)+" "+str(rect_position.y))

func showMenu(pj):
	player=pj
	rect_position=player.position
	rect_position.y-=25
	print("SHOW MENU")
	visible=true
	selectSubMenu("MenuP")

func hideMenu():
	visible=false
	if player.has_method("on_exit_menu"):
		player.on_exit_menu("")#puede retornar informacion al player

func isActive():
	return visible

func acceptButton():
	#Acciones de cada boton del menu
	if Input.is_action_just_pressed('ui_accept'):
		if isBtn("MenuP","BTN_EQ"): selectSubMenu("MenuEq")
		#elif isBtn("MenuEq","BTN_ATK"): selectSubMenu("MenuP")

func cancelButton():
	#Acciones del boton de cancelar (no deberian cambiar)
	if Input.is_action_just_pressed('ui_cancel'):
		if isBtn("MenuP"): hideMenu()
		elif isBtn("MenuEq"): selectSubMenu("MenuP")

func selectSubMenu(name):	
	get_node(current_menu).visible=false
	current_menu=name
	var M=get_node(current_menu)
	M.visible=true
	menu_position=M.rect_position	
	menu_childrens=M.get_children()
	max_index=menu_childrens.size()-1
	index=0
	button_size=menu_childrens[0].rect_size
	button_size.y=0;
	reposition_selector()

func isBtn(menu_name,btn_name="NONE"):
	if btn_name=="NONE": return (current_menu==menu_name)
	else: return (current_menu==menu_name)&&(menu_childrens[index].name==btn_name)
	menu_childrens