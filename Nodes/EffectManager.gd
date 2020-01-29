extends Node2D

var work_scene = preload("res://Nodes/Effects/workEff.tscn")
var text_scene = preload("res://Nodes/Effects/textEff.tscn")
var anim_scene = preload("res://Nodes/Effects/anim.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func work_effect(tile_pos,ttl=0):
	var wpos=Globals.tile_map.map_to_world(tile_pos)+Globals.tile_size/2
	var node = work_scene.instance()
	node.init(wpos,ttl)
	add_child( node )
	return node

func text_effect(pos,txt):
	var node = text_scene.instance()
	node.init(pos,txt)
	add_child( node )
	return node

func titilar(obj):
	var tween = obj.get_node("Tween")
	if !tween:
		tween=Tween.new()
		obj.add_child(tween)
		
	tween.interpolate_property(obj, "modulate",Color(0.5,0.5,0.5), Color(1,1,1), 0.3,Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	tween.interpolate_property(obj, "modulate",Color(0.5,0.5,0.5), Color(1,1,1), 0.3,Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	tween.interpolate_property(obj, "modulate",Color(0.5,0.5,0.5), Color(1,1,1), 0.3,Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()

func hit_effect(pos):
	var node = anim_scene.instance()
	node.position=pos
	node.get_node("AnimatedSprite").play("default")
	add_child( node )
	yield(get_tree().create_timer(0.8), "timeout")
	node.free()