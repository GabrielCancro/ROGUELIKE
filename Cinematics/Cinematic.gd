extends CanvasLayer

var CURRENT_CINEMATIC
var FINISHED=false

func _ready():
	$lbl_skip/skip.connect("pressed",self,"finish_cinematic")

func show_black(): $blackground.visible=true
func hide_black(): $blackground.visible=false

func start_cinematic(cinematic_name):
	Globals.SoundsManager.pause_music()
	Globals.turnController.set_stoped_game(true)
	FINISHED=false
	$lbl_skip.visible=false
	
	CURRENT_CINEMATIC=load("res://Cinematics/"+cinematic_name+"/"+cinematic_name+".tscn")
	CURRENT_CINEMATIC=CURRENT_CINEMATIC.instance()
	add_child(CURRENT_CINEMATIC)

func finish_cinematic():
	FINISHED=true
	$lbl_skip.visible=false
	CURRENT_CINEMATIC.queue_free()
	Globals.SoundsManager.resume_music()
	Globals.turnController.set_stoped_game(false)

func cinema_tween(obj,OPT):
	if FINISHED: return
	#OPT={EFFECT:"DISOLVE",DURATION:1,DELAY:0,IALPHA:1,EALPHA:0}
	var tween=Tween.new()
	obj.add_child(tween)
	
	if (OPT.get("DELAY",0)>0): yield(get_tree().create_timer(OPT.get("DELAY",0)), "timeout")
	if FINISHED: return
	if(OPT.get("EFFECT")=="DISOLVE"):
		var ini_modulate=obj.modulate
		ini_modulate.a=1
		var end_modulate=obj.modulate
		end_modulate.a=0
		tween.interpolate_property(obj, "modulate",ini_modulate, end_modulate, OPT.get("DURATION",1),Tween.TRANS_QUAD, Tween.EASE_OUT)
	elif(OPT.get("EFFECT")=="APARECER"):
		var ini_modulate=obj.modulate
		ini_modulate.a=0
		var end_modulate=obj.modulate
		end_modulate.a=1
		tween.interpolate_property(obj, "modulate",ini_modulate, end_modulate, OPT.get("DURATION",1),Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	elif(OPT.get("EFFECT")=="ROTATE"):
		tween.interpolate_property(obj, "rotation_degrees",obj.rotation_degrees, obj.rotation_degrees+OPT.get("ANGLE",360), OPT.get("DURATION",1),Tween.TRANS_QUAD, Tween.EASE_OUT)
	elif(OPT.get("EFFECT")=="SCALE"):
		tween.interpolate_property(obj, "scale",obj.scale, Vector2(OPT.get("VALUE",.5),OPT.get("VALUE",.5)), OPT.get("DURATION",1),Tween.TRANS_QUAD, Tween.EASE_OUT)
		
	tween.start()
#	print("INICIA "+OPT.get("EFFECT"))
	yield(tween, "tween_completed")
	if FINISHED: return
	tween.queue_free()

func show_skip(time):
	yield(get_tree().create_timer(time), "timeout")
	$lbl_skip.visible=true
