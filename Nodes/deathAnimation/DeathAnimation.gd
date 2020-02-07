tool
extends Node2D
export var nextScene:PackedScene
var playerDied:=false

func ThePlayerDied():
	#LLamar a esta funcion si el jugador murio
	#Esta funcincion hace las animaciones necesarias y llama a una nueva escena
	$AnimationPlayer.play("FadeScreen")
	yield($AnimationPlayer,"animation_finished")
	$CanvasLayer/Label.visible=true
	$CanvasLayer/restarText.visible=true
	playerDied=true
	
func _input(event):
	#para cambiar de escena al precionar r
	if Input.is_key_pressed(KEY_R) and playerDied: get_tree().change_scene_to(nextScene)
	
	
func _get_configuration_warning() ->String:
	return "La propiedad Next Scene debe ser completada" if not nextScene else ""