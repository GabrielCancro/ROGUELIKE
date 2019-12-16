extends KinematicBody2D

# Declare member variables here. Examples:
var speed = 150
var velocity = Vector2()
var path: = PoolVector2Array() setget set_path
var moveToPath:bool=false
var indexPath
var STATE="MOVE"

signal onChangeHp

var work_scene = preload("res://Nodes/workEff.tscn")

onready var nav_2D:Navigation2D=get_node("../Nav2D")
onready var tile_map:TileMap=get_node("../Nav2D/TileMap")
onready var menu=get_node("../RootMenu")
onready var data=get_node("data")

# Called when the node enters the scene tree for the first time.
func _ready():
	position=Vector2(32*7+16,32*5+16)
	add_to_group("objetos")
	yield(get_tree().create_timer(0.2), "timeout")
	addHp(0)

func get_input():
# Detect up/down/left/right keystate and only move when pressed.
	var v = Vector2(0,0)
	if Input.is_action_pressed('ui_right'): v.x += 1
	if Input.is_action_pressed('ui_left'): v.x -= 1
	if Input.is_action_pressed('ui_down'): v.y += 1
	if Input.is_action_pressed('ui_up'): v.y -= 1
	if v.x!=0: get_node( "Sprite" ).set_flip_h( v.x==-1 )
	if moveToPath: movePath()
	elif v.x!=0 || v.y!=0:
		#var new_path = nav_2D.get_simple_path(position, nav_2D.get_tilemap_pos(position+v*32))
		#get_node("../Nav2D/Line2D").points=new_path
		var myTileDes=getTilePos()+v
		var myDes=tile_map.map_to_world(myTileDes)+tile_map.cell_size/2
		var cell_des=tile_map.get_cellv(myTileDes)
		if(cell_des==3 || cell_des==10):
			set_path([position,myDes])
			get_node("/root/Node2D/DungeonGenerator").showFog(myTileDes.x,myTileDes.y,6)
		elif cell_des==8:			
			set_work("OPEN",myTileDes)
	if Input.is_action_just_released('ui_accept'): 
			setState("MENU")
			menu.showRootMenu(self)
	if Input.is_action_just_released('ui_select'): 
		print(get_tree().get_root().name)
		get_tree().get_root().get_node('Node2D/DungeonGenerator').generateDungeon(tile_map)

func setState(_state):
	yield(get_tree().create_timer(0.1), "timeout")
	STATE=_state

func on_exit_menu(data):
	if data["action"]=="NONE": 
		setState("MOVE")
	elif data["action"]=="CAST":
		showSelectorTilePos(data)

func on_exit_selector(data):
	if data.has("tilePos"):
		set_work("OPEN",data.get("tilePos"))
	else: setState("MOVE")

func getTilePos():
	return tile_map.world_to_map(position)

func _physics_process(delta):
	get_node('/root/Node2D/UIControl/STATE_Label').set_text("S: "+STATE)
	if STATE=="MOVE": 
		get_input()
		move_and_slide(velocity)

func set_work(name,pos):
	STATE="WORK"
	if(name=="OPEN"):
		var node = work_scene.instance()
		node.position=tile_map.map_to_world(pos)+tile_map.cell_size/2
		tile_map.add_child( node )
		yield(get_tree().create_timer(3.0), "timeout")
		tile_map.set_cell(pos.x,pos.y,10)
		STATE="MOVE"
		node.free()	

func set_path(value: PoolVector2Array)->void:
	path=value
	moveToPath=true
	indexPath=0

func movePath():	
	if path.size()<=0: return
	var start_point: = position
	var next_point: = path[indexPath]
	var distance_to_next: = start_point.distance_to(next_point)
	if distance_to_next>5.0:
		var direction = ( next_point - start_point ).normalized()
		velocity=direction*speed
	else:
		indexPath+=1
		#position=next_point
		velocity=Vector2(0,0)
	#print(str(distance_to_next)+"-"+str(velocity.x)+","+str(velocity.y))
	if indexPath>=path.size():
		moveToPath=false

func addHp(num):
	print("PLAYER.addHp "+str(num))
	data.baseAttr[".hp"]+=num
	emit_signal("onChangeHp", data.baseAttr[".hp"], data.baseAttr["hp"])

func showSelectorTilePos(data):
	STATE="TILE_SELECTOR"
	var SPJ=get_node("../UIControl/SelectPj")
	SPJ.showSelector(self,data)