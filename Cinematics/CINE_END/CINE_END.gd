extends Node2D

func _ready():
	$img1.modulate.a=0
	Globals.Cinematic.cinema_tween( $img2, {"EFFECT":"APARECER","DURATION":3} )
	Globals.Cinematic.cinema_tween( $img2, {"EFFECT":"ROTATE","ANGLE":40, "DURATION":20} )
	
	$txt1.modulate.a=0
	$txt2.modulate.a=0
	$txt3.modulate.a=0
	$txt4.modulate.a=0
	$txt5.modulate.a=0
	
	Globals.Cinematic.cinema_tween( $txt1, {"EFFECT":"APARECER","DURATION":5,"DELAY":0} )
	Globals.Cinematic.cinema_tween( $txt2, {"EFFECT":"APARECER","DURATION":5,"DELAY":2} )
	Globals.Cinematic.cinema_tween( $txt3, {"EFFECT":"APARECER","DURATION":5,"DELAY":4} )
	Globals.Cinematic.cinema_tween( $txt4, {"EFFECT":"APARECER","DURATION":5,"DELAY":5} )
	Globals.Cinematic.cinema_tween( $txt5, {"EFFECT":"APARECER","DURATION":5,"DELAY":8} )
	
	Globals.Cinematic.cinema_tween( $img1, {"EFFECT":"APARECER","DURATION":3,"DELAY":9} )
	Globals.Cinematic.cinema_tween( $img1, {"EFFECT":"ROTATE","ANGLE":40, "DURATION":10, "DELAY":9} )


func _process(delta):
	if Input.is_action_just_released('ui_accept'): 
			Globals.Cinematic.finish_cinematic()
			get_tree().change_scene_to( load("res://Nodes/menuPrincipal/menu_principal.tscn") )
