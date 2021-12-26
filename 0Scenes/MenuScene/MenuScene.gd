extends Node2D

var rnd=RandomNumberGenerator.new()
var input_enabled=true
var tick_flap_light=0
var reduct_light=false
onready var light_size=$Light2D.scale*100
var buttons
var ibutton

# Called when the node enters the scene tree for the first time.
func _ready():
	rnd.randomize()	
	set_current_menu("MAIN")

func _process(delta):
	flap_light()
	get_input()

func get_input():
	if !input_enabled: return
	if Input.is_action_pressed('ui_right'): pass
	if Input.is_action_pressed('ui_left'): pass
	if Input.is_action_just_pressed('ui_up'): prev_button()
	if Input.is_action_just_pressed('ui_down'): next_button()
	if Input.is_action_just_pressed('ui_accept'): action_button()
	if Input.is_action_just_pressed('ui_cancel'): cancel_button()
	if Input.is_action_just_released('ui_select'): pass
	if Input.is_action_just_released('toggle_mode'): pass

func prev_button():
	if ibutton>0: 
		ibutton-=1
		$SFX01.play()
	set_text_buttons()

func next_button():
	if ibutton<buttons.size()-1: 
		ibutton+=1
		$SFX01.play()
	set_text_buttons()

func set_text_buttons():
	$Buttons/prev2.text=""
	$Buttons/prev.text=""
	$Buttons/next.text=""
	$Buttons/next2.text=""
	$Buttons/current.text=buttons[ibutton]["title"]
	if ibutton-2>=0: $Buttons/prev2.text=buttons[ibutton-2]["title"]
	if ibutton-1>=0: $Buttons/prev.text=buttons[ibutton-1]["title"]
	if ibutton+1<=buttons.size()-1: $Buttons/next.text=buttons[ibutton+1]["title"]
	if ibutton+2<=buttons.size()-1: $Buttons/next2.text=buttons[ibutton+2]["title"]

func action_button():
#	reduct_light=true
#	input_enabled=false
#	yield(get_tree().create_timer(1), "timeout")
	$SFX01.play()
	var ido=buttons[ibutton]["code"]
	if(ido=="QUIT"): get_tree().quit()
	if(ido=="SCORE"): get_tree().change_scene( "res://0Scenes/ScoreScene/Score.tscn" )
	if(ido=="OPTIONS"): set_current_menu("OPTIONS")
	if(ido=="DESCEND"):
		set_current_menu("CONTINUE_MENU")
	if(ido=="START"): 
		$Buttons.visible=false
		input_enabled=false
		Globals.OPTIONS.DATA_SAVE["score"]=0
		Globals.OPTIONS.DATA_SAVE["encurso"]=false
		Globals.OPTIONS.save_options()
		$SceneLoader.load_scene( "res://Game/GameScene.tscn" )
	if(ido=="CONTINUE"): 
		$Buttons.visible=false
		input_enabled=false
		#Globals.OPTIONS.DATA_SAVE["encurso"]=true # es true si o si
		$SceneLoader.load_scene( "res://Game/GameScene.tscn" )
	if(ido=="CREDITS"): get_tree().change_scene( "res://0Scenes/CreditsScene/CreditsScene.tscn" )
	
	
	if(ido=="BACK"): set_current_menu("MAIN")

func  cancel_button():
	$SFX01.play()
	set_current_menu("MAIN")

func flap_light():
	if tick_flap_light<2:
		tick_flap_light+=1
		return
	if reduct_light: 
		light_size*=Vector2(0.9,0.6)
		$Light2D.color.a*=0.9
	tick_flap_light=0
	var x=rnd.randi_range(light_size.x,light_size.x*1.2)
	var y=rnd.randi_range(light_size.y,light_size.y*1.2)
	$Light2D.set_scale(Vector2(x,y)/100)
	$Light2D2.color.a=rnd.randf_range(.3,0.9)
	$Light2D3.color.a=rnd.randf_range(.3,0.9)

func second_lights():
	pass

func set_current_menu(MENU):
	ibutton=1
	buttons=[]
	if MENU=="MAIN":
		buttons.append({"code":"OPTIONS", "title": "Opciones" })
		buttons.append({"code":"DESCEND", "title": "Precipitarse\nal Abismo" })
		buttons.append({"code":"SCORE", "title": "Fosa de\nlos Caídos" })
		buttons.append({"code":"CREDITS", "title": "Créditos" })
		buttons.append({"code":"QUIT", "title": "Salir" })
	elif MENU=="OPTIONS":
		buttons.append({"code":"CONTROLS", "title": "Controles" })
		buttons.append({"code":"VOLUME", "title": "Volumen" })
		buttons.append({"code":"VIDEO", "title": "Video" })
		buttons.append({"code":"BACK", "title": "Volver" })
	elif MENU=="CONTINUE_MENU":
		ibutton=0
		if(Globals.OPTIONS.DATA_SAVE["encurso"]):
			buttons.append({"code":"CONTINUE", "title": "Continuar\ntravesía" })
			buttons.append({"code":"START", "title": "Recomenzar\ntravesía" })
		else: buttons.append({"code":"START", "title": "Nueva\ntravesía" })
		buttons.append({"code":"BACK", "title": "Volver" })
	set_text_buttons()
