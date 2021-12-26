extends Node2D

# Declare member variables here. Examples:
# var a = 2
var PREDIAG={}

# Called when the node enters the scene tree for the first time.
func _ready():
	PREDIAG["T1"]="El lugar es frio y silencioso, intenta caminar hasta el final del pasillo."
	PREDIAG["T2"]="Una puerta de madera carcomida parece la unica salida, avanza hacia ella para intentar abrirla, si no lo logras puedes seguir intentandolo."
	PREDIAG["T3"]="Parece un salon, debe haber algo interesante aqui."
	PREDIAG["T4"]="Podras abrir el menu de personaje presionando el boton ["+Globals.BTNS[0]+"] en cualquier momento. "
	PREDIAG["T4"]+="Cuando recojas armas u otros items deberas equipartelos desde tu menu de personaje."
	PREDIAG["T5"]="Se escuchan ruidos en la siguiente habitacion, parece que tendras que luchar para poder continuar tu camino."
	PREDIAG["T6"]="Despues de un combate es probable que quedes malherido, podras curarte utilizando las fuentes o comiendo algunos alimentos."
	PREDIAG["T7"]="Ese altar tiene una energia especial, algo en el te es familiar y te sientes atraido. (utilizalo para mejorar tus habilidades)"
	PREDIAG["T8"]="Las profundas escaleras parecen ser la unica forma de seguir adelante. (en todos los niveles encontraras una fuente y un altar, te seran de mucha ayuda)"
	
	hide()
	pass # Replace with function body.

func _process(delta):
	if Globals.CONTROL_INPUT!="DIALOG": return
	$label.visible_characters+=1
	if $label.visible_characters>=$label.text.length(): $SFX.stop()
	if Input.is_action_pressed('ui_accept'): $label.visible_characters+=4
	if Input.is_action_just_pressed('ui_accept'):
		if $label.visible_characters>=$label.text.length():
			$SFX.stop()
			Globals.DialogsManager.hide() 
			

func diag(txt):
	print("diag")
	var lines=int(txt.length()/25)
	$NinePatchRect.rect_size.y=23+33*lines
	$label.visible_characters=0
	$label.bbcode_text=txt
	visible=true
	set_process(true)
	$SFX.play()
	Globals.set_CONTROL_INPUT("DIALOG")
	
func hide():
	visible=false
	set_process(false)
	yield(get_tree().create_timer(.2), "timeout")
	Globals.set_CONTROL_INPUT("PLAYER")
