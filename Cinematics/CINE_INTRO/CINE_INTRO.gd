extends Node2D

var ttl=150

func _ready():
	$img1.modulate.a=0
	Globals.Cinematic.cinema_tween( $img1, {"EFFECT":"APARECER","DURATION":3} )
	Globals.Cinematic.cinema_tween( $img1, {"EFFECT":"DISOLVE","DURATION":8,"DELAY":2} )
	Globals.Cinematic.cinema_tween( $img1, {"EFFECT":"ROTATE","ANGLE":60, "DURATION":12} )
	Globals.Cinematic.cinema_tween( $img1, {"EFFECT":"SCALE","VALUE":.6, "DURATION":13,"DELAY":2} )
	
	$txt1.modulate.a=0
	$txt2.modulate.a=0
	$txt3.modulate.a=0
	$txt4.modulate.a=0
	$txt5.modulate.a=0
	
	Globals.Cinematic.cinema_tween( $txt1, {"EFFECT":"APARECER","DURATION":5,"DELAY":0} )
	Globals.Cinematic.cinema_tween( $txt1, {"EFFECT":"DISOLVE","DURATION":2,"DELAY":4} )
	Globals.Cinematic.cinema_tween( $txt2, {"EFFECT":"APARECER","DURATION":5,"DELAY":2} )
	Globals.Cinematic.cinema_tween( $txt2, {"EFFECT":"DISOLVE","DURATION":2,"DELAY":6} )
	Globals.Cinematic.cinema_tween( $txt3, {"EFFECT":"APARECER","DURATION":5,"DELAY":4} )
	Globals.Cinematic.cinema_tween( $txt3, {"EFFECT":"DISOLVE","DURATION":2,"DELAY":8} )
	Globals.Cinematic.cinema_tween( $txt4, {"EFFECT":"APARECER","DURATION":5,"DELAY":5} )
	Globals.Cinematic.cinema_tween( $txt4, {"EFFECT":"DISOLVE","DURATION":2,"DELAY":9} )
	Globals.Cinematic.cinema_tween( $txt5, {"EFFECT":"APARECER","DURATION":5,"DELAY":8} )
	Globals.Cinematic.cinema_tween( $txt5, {"EFFECT":"DISOLVE","DURATION":2,"DELAY":11} )
	
	Globals.Cinematic.show_skip(3)
	
	yield(get_tree().create_timer(13), "timeout")
	Globals.Cinematic.finish_cinematic()