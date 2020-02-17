extends Node2D

var tick=0
var light_size:Vector2
var input_enabled=false
var rnd=RandomNumberGenerator.new()
var buttonSelect=""

# Called when the node enters the scene tree for the first time.
func _ready():
	rnd.randomize()
	selectButton("btn1")
	iniMusic()
	yield(get_tree().create_timer(1), "timeout")
	input_enabled=true
	pass # Replace with function body.

func iniMusic():
	var player=AudioStreamPlayer.new()
	self.add_child(player)
	player.stream=load("res://Sounds/music_main.ogg")
	player.play()

func selectButton(btn):
	buttonSelect=btn	
	var BTN=get_node('/root/Node2D/Buttons/'+btn)
	var BTN_POS=BTN.rect_position+BTN.rect_size/2
	if btn=="btn1": light_size=Vector2(200,80)
	elif btn=="btn2": light_size=Vector2(100,150)
	elif btn=="btn3": light_size=Vector2(100,150)
	elif btn=="btn4": light_size=Vector2(150,80)
	$Tween.interpolate_property(self,'position',position,BTN_POS,0.5,Tween.TRANS_EXPO,Tween.EASE_OUT)
	$Tween.start()
	#position=BTN_POS

func get_input():
	if !input_enabled: return
	var v = Vector2(0,0)
	if Input.is_action_pressed('ui_right'): selectButton("btn3")
	if Input.is_action_pressed('ui_left'): selectButton("btn2")
	if Input.is_action_pressed('ui_down'): selectButton("btn1")
	if Input.is_action_pressed('ui_up'): selectButton("btn4")
	if Input.is_action_just_pressed('ui_accept'): 
		if buttonSelect=='btn1': 
			#get_tree().change_scene("res://Nodes/main.tscn")
			get_node("/root/Node2D").goto_scene("res://Nodes/main.tscn",get_node('/root/Node2D/Buttons/btn1') )
		elif buttonSelect=='btn3': get_tree().quit()
	if Input.is_action_just_released('ui_select'): pass
	if Input.is_action_just_released('toggle_mode'): pass

func _process(delta):
	get_input()
	tick+=1
	if tick>3:
		tick=0
		var x=rnd.randi_range(light_size.x,light_size.x*1.2)
		var y=rnd.randi_range(light_size.y,light_size.y*1.2)
		set_scale(Vector2(x,y)/100)
#		BTN_GOTO.set("custom_colors/font_color", Color(dc,dc,dc/2))