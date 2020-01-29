extends Node2D

var ttl
signal sg_finish

func init(world_pos, timeToLife=1):
	ttl=timeToLife
	position=world_pos

func _ready():    
	yield(get_tree().create_timer(ttl), "timeout")
	emit_signal("my_signal")
	free()

func _process(delta):
	rotation_degrees+=5
