extends Node2D

# Declare member variables here. Examples:
var current_menu="NONE"
var player: Node2D

func _ready(): 
	visible=false

func showRootMenu(pj,subMenu="MenuP"):
	player=pj
	position=player.position
	position.y-=60
	if position.x<100: position.x=100
	if position.y<70: position.y=70
	print("SHOW MENU")
	visible=true
	selectSubMenu(subMenu)

func exitRootMenu(data={"action":"NONE"}):
	visible=false
	if current_menu!="NONE": get_node(current_menu).hide()
	current_menu="NONE"
	if player.has_method("on_exit_menu"):
		player.on_exit_menu(data)#puede retornar informacion al player

func selectSubMenu(name):
	if current_menu!="NONE": get_node(current_menu).hide()
	current_menu=name
	get_node(current_menu).show()

func getPlayer():
	return player