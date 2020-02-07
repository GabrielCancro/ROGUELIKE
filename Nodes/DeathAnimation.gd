tool
extends Node2D

export var nextScene:PackedScene
var playerDied:=false

func _ready():
	#LLamar a esta funcion si el jugador murio
	#Esta funcincion hace las animaciones necesarias y llama a una nueva escena
	$GameOverSound.play()
	$AnimationPlayer.play("FadeScreen")
	yield($AnimationPlayer,"animation_finished")
	playerDied=true
	
#func _process(delta):
#	#para cambiar de escena al precionar
#	if Input.is_action_just_released((ANY_) and playerDied:
#		get_tree().change_scene_to(nextScene)

func _input(event):
	if playerDied:
		get_tree().change_scene_to(nextScene)
	
func _get_configuration_warning() ->String:
	return "La propiedad Next Scene debe ser completada" if not nextScene else ""