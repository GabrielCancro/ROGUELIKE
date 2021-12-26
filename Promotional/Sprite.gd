extends Sprite

# Declare member variables here. Examples:
# var a = 2
var da=-0.03
export var ini_frame = [1, 2, 3, 4, 5]
var i=0

# Called when the node enters the scene tree for the first time.
func _ready():
	var rnd=RandomNumberGenerator.new()
	rnd.randomize()
	rotation_degrees=rnd.randi()%150
	modulate.a=0.3+rnd.randf()*0.4
	frame=ini_frame[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees+=5
	modulate.a+=da
	if modulate.a<0.1: 
		da=abs(da)
		i+=1
		frame=ini_frame[i]
	if modulate.a>0.95: da=-abs(da)
