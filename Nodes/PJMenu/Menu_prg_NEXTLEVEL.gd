extends Control

onready var RootMenu=get_node("../")

func _ready(): 
	hide()

func show(): 
	visible=true
	$Tween.interpolate_property(self, "modulate",Color(1,1,1,0), Color(1,1,1,1), .5, $Tween.TRANS_QUAD, $Tween.EASE_OUT)
	$Tween.interpolate_property(self, "rect_position",Vector2(-80,-40), Vector2(-80,-80), .5, $Tween.TRANS_QUAD, $Tween.EASE_OUT)
	$Tween.start()
	Globals.SoundsManager.play_sfx("UI_accept")
	set_process(true)
	
func hide(): 
	visible=false
	modulate=Color(1,1,1,0)
	Vector2(0,-40)
	set_process(false)

func _onAccept():
	Globals.nextDungeon()
	RootMenu.exitRootMenu()

func _onCancel(): 
	RootMenu.exitRootMenu()

func _process(delta): #inputs.. que se desactivan y activan en onShow onHide
	if Input.is_action_just_released('ui_accept'): _onAccept()
	if Input.is_action_just_released('ui_cancel'): _onCancel()
