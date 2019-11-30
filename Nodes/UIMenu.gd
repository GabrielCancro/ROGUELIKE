extends Control

# Declare member variables here. Examples:
var current_menu="NONE"
var player: Node2D

func _ready(): visible=false

func showRootMenu(pj):
	player=pj
	rect_position=player.position
	rect_position.y-=25
	print("SHOW MENU")
	visible=true
	selectSubMenu("MenuP")

func exitRootMenu():
	visible=false
	if current_menu!="NONE": get_node(current_menu).hide()
	current_menu="NONE"
	if player.has_method("on_exit_menu"):
		player.on_exit_menu("")#puede retornar informacion al player

func selectSubMenu(name):
	if current_menu!="NONE": get_node(current_menu).hide()
	current_menu=name
	get_node(current_menu).show()

func getPlayer():
	return player