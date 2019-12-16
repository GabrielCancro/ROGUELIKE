extends Camera2D

onready var player:Camera2D=get_tree().get_root().get_node("Node2D/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	print(str(get_viewport().size))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_position(player.position)
