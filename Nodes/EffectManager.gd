extends Node2D

var work_scene = preload("res://Nodes/Effects/workEff.tscn")
var text_scene = preload("res://Nodes/Effects/textEff.tscn")
var fonts={}
var anim_scene = preload("res://Nodes/Effects/anim.tscn")
var fx_magic_scene = preload("res://Nodes/Effects/fx_magic.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	fonts["GIANT"]=preload("res://Fonts/Giant_font.tres")
	fonts["GIANT_COLOR"]=Color(.9,.9,.9,1)
	fonts["STEPS"]=preload("res://Fonts/Steps_font.tres")
	fonts["STEPS_COLOR"]=Color(.7,.7,.7,1)
	fonts["LIFE"]=fonts["STEPS"]
	fonts["LIFE_COLOR"]=Color(1,.5,.5,1)
	fonts["POWER"]=fonts["STEPS"]
	fonts["POWER_COLOR"]=Color(.5,.5,1,1)
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
	node.get_node("Label").get("custom_fonts/font").set_size(24)
	return node

func custom_text_effect(pos,cstm,txt):
	var label = text_effect(pos,txt).get_node("Label")
	label.add_font_override("font", fonts[cstm])
	label.add_color_override("font_color", fonts[cstm+"_COLOR"])

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

func magic_effect(pos):
	var node = fx_magic_scene.instance()
	node.position=pos
	node.get_node("AnimatedSprite").play("default")
	add_child( node )
	yield(get_tree().create_timer(1.5), "timeout")
	node.free()