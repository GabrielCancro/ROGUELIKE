extends CanvasLayer

func _ready():
	print (str(OS.get_name() ))	
	if OS.get_name()=="Android":
#	if true:
		Globals.BTNS=["A","B"]
		for BTN in get_children():
			BTN.modulate.a=0.3
	else: queue_free()
		
