extends Node2D

# Declare member variables here. Examples:
# var a = 2
var ttl = 120
var publicando=false
onready var score=Globals.OPTIONS.DATA_SAVE["score"]

# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	$Control/Button.connect("pressed", self, "_on_Button_pressed")
	$Control/Btn_back.connect("pressed", self, "_on_Btn_back_pressed")
	$Control/TextEdit.connect("text_changed",self,"on_texedit_text_changed")
	$Control/Label.text="Score: "+str(score)
	$Control.visible=false
	$Fondo.modulate.a=0
	$Calaca.modulate.a=0
	$AudioStreamPlayer.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Fondo.modulate.a+=0.005
	$Calaca.modulate.a+=0.004
	if ttl==0:
		$Control.visible=true
#		get_tree().change_scene("res://menuPrincipal/menu_principal.tscn")
	else: ttl-=1

func _on_Button_pressed():
	if publicando: return
	$Control/Button.text="Publicando Score"
	$Control/Button.disabled=true
	publicando=true
	#var url="http://crplay.tk/gcscore/gcscore.php?game=ROGUELIKE&op=getscores"
	var url="http://crplay.tk/gcscore/gcscore.php?game=ROGUELIKE&op=addscore"
	url+="&player="+$Control/TextEdit.text
	url+="&score="+str(score)
	$HTTPRequest.request(url)

func _on_Btn_back_pressed():
	get_tree().change_scene( "res://0Scenes/ScoreScene/Score.tscn" )

func _on_request_completed(result, response_code, headers, body):
	get_tree().change_scene( "res://0Scenes/ScoreScene/Score.tscn" )
#	print("request complete!")
#	var json = JSON.parse(body.get_string_from_utf8())
#	print(json.result)

func on_texedit_text_changed():
	var mx=12
	if $Control/TextEdit.text.length()>mx:
		$Control/TextEdit.text=$Control/TextEdit.text.substr(0,mx)
		$Control/TextEdit.cursor_set_column(mx)
		
