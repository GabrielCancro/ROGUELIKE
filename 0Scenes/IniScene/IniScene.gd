extends Node2D

func _ready():
	Globals.OPTIONS.load_options()
	$opacar/AnimationPlayer.play("opacar")

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://0Scenes/MenuScene/MenuScene.tscn")
