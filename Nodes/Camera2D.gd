extends Camera2D

var target=null
# Called when the node enters the scene tree for the first time.
func _ready():
	print(str(get_viewport().size))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target!=null: 
		position=target.position

func setTarget(trg):
	target=trg

