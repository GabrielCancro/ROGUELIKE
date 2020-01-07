extends Node2D

# Declare member variables here. Examples:
var a=5.0
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_text(txt):
	$Label.set_text(txt)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	a*=0.9
	if a>1: position.y-=a

