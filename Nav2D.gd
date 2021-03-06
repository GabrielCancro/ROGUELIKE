extends Navigation2D

onready var nav_2d:Navigation2D=self
onready var line_2d:Line2D=$Line2D
onready var tile_map:TileMap=$TileMap
onready var cell_size =tile_map.cell_size;
onready var character:KinematicBody2D=get_node("../Player")

var enemies_tilegroup={}

func _unhandled_input(e:InputEvent)->void:
	if not e is InputEventMouseButton:
		return
	if e.button_index != BUTTON_LEFT or not e.pressed:
		return
	
	#Globals.effectManager.text_effect(Globals.player.position,'test',1)
#	var new_path : = nav_2d.get_simple_path(character.global_position, get_tilemap_pos(e.global_position),false)
#	line_2d.points=new_path
#	character.path = new_path
	
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals._initGlobals()
	pass # Replace with function body.

func get_tilemap_pos(worldPosition):
	var v=tile_map.world_to_map( worldPosition )*cell_size+Vector2(cell_size.x/2,cell_size.y/2+1)
	return v

func drawPath(path):
	var worldPath=[]
	for pos in path:
		worldPath.append(Globals.tile_map.map_to_world(pos)+Globals.tile_size/2)
	line_2d.points=worldPath
