extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var work_scene = preload("res://Nodes/Effects/workEff.tscn")
var text_scene = preload("res://Nodes/Effects/textEff.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func work_effect(pos,ttl=0):
	var node = work_scene.instance()
	node.position=Globals.tile_map.map_to_world(pos)+Globals.tile_size/2
	add_child( node )
	if ttl>0:
		yield(get_tree().create_timer(ttl), "timeout")
		node.free()
	return node

func text_effect(pos,txt,ttl=0):
	var node = text_scene.instance()
	node.position=pos
	node.set_text(txt)
	add_child( node )
	if ttl>0:
		yield(get_tree().create_timer(ttl), "timeout")
		node.free()
	return node