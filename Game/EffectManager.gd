extends Node2D

var text_scene = preload("res://Game/Effects/textEff.tscn")
var fonts={}
var sheets={}

# Called when the node enters the scene tree for the first time.
func _ready():
	fonts["GIANT"]=preload("res://Fonts/Giant_font.tres")
	fonts["GIANT_COLOR"]=Color(.9,.9,.9,1)
	fonts["GIANT_EARLY"]=fonts["GIANT"]
	fonts["GIANT_EARLY_COLOR"]=Color(.8,.8,.8,.7)
	fonts["STEPS"]=preload("res://Fonts/Steps_font.tres")
	fonts["STEPS_COLOR"]=Color(.7,.7,.7,1)
	fonts["LIFE"]=fonts["STEPS"]
	fonts["LIFE_COLOR"]=Color(1,.5,.5,1)
	fonts["POWER"]=fonts["STEPS"]
	fonts["POWER_COLOR"]=Color(.5,.5,1,1)
	
	sheets["FIRE"]={"spr":preload("res://sprites/fx/fire_sheet.png"), 
	"HF":8, "VF":8, "FRAMES":30, "FPS":15, "TIME":-1}
	
	sheets["MAGIC"]={"spr":preload("res://sprites/fx/magic_sheet.png"), 
	"HF":5, "VF":4, "FRAMES":18, "FPS":15,"TIME":-1}
	
	sheets["SLASH"]={"spr":preload("res://sprites/fx/slash_sheet.png"), 
	"HF":7, "VF":1, "FRAMES":7, "FPS":-1,"TIME":0.5}
	
	sheets["WORK"]={"spr":preload("res://sprites/fx/work_sheet.png"), 
	"HF":16, "VF":1, "FRAMES":16, "FPS":-1,"TIME":1.2}
	
	sheets["EXPLODE"]={"spr":preload("res://sprites/fx/explode_sheet.png"), 
	"HF":8, "VF":2, "FRAMES":16, "FPS":-1,"TIME":.6}

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
	var tween
	if obj.has_node("Tween"):
		tween = obj.get_node("Tween")
	else:
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

func sheet_fx(NAME_EFFECT,pos):
	#spr HF VF FRAMES FPS TIME
	var FX=sheets[NAME_EFFECT]
	var SPR=Sprite.new()
	SPR.texture=FX["spr"]
	SPR.hframes=FX["HF"]
	SPR.vframes=FX["VF"]
	var time = 1.0
	if FX.get("FPS",0)>0: time=float(FX["FRAMES"])/FX["FPS"]
	if FX.get("TIME",0)>0: time=FX["TIME"]
	SPR.position=pos
	
	var TW=Tween.new()
	TW.interpolate_property(SPR, "frame", 0, FX["FRAMES"], time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	
	SPR.add_child(TW)
	add_child(SPR)
	TW.start()
	yield(TW, "tween_completed")
	remove_child(SPR)
	TW.queue_free()
	SPR.queue_free()
	
