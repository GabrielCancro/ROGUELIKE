extends Node2D

# Declare member variables here. Examples:
signal sg_finish

func init(world_pos, text):
	set_text(text)
	position=world_pos
	position.y-=25

func _ready():    
	yield(get_tree().create_timer(1), "timeout")
	emit_signal("my_signal")
	free()
	
func set_text(txt):
	$Label.set_text(txt)

var a=5
func _process(delta):
	a*=0.8
	if a>1: position.y-=a

