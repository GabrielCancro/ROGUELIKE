extends Node2D

func _ready():
	clear_table()
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	$Button.connect("pressed",self,"_on_return_button")
	var url="http://crplay.tk/gcscore/gcscore.php?game=ROGUELIKE&op=getscores"
	#http://crplay.tk/gcscore/gcscore.php?game=ROGUELIKE&op=addscore&player=Mole&score=300
	$HTTPRequest.request(url)

func _on_request_completed(result, response_code, headers, body):
	print("request complete!")
	var json = JSON.parse(body.get_string_from_utf8())
	show_table(json.result)

func show_table(data):
	clear_table()
	$Buscando.text=""
	for line in data:
		$name.bbcode_text+=line["player"]+" \n"
		$score.bbcode_text+=str(line["score"])+" \n"
		$fecha.bbcode_text+=" "+str(line["date"])+" \n"
		print(line)

func clear_table():
	$name.bbcode_text="[right]"
	$score.bbcode_text="[right]"
	$fecha.bbcode_text=""

func _input(event):
	if Input.is_action_just_pressed('ui_cancel'): 
		_on_return_button()

func _on_return_button():
	get_tree().change_scene( "res://0Scenes/MenuScene/MenuScene.tscn" )
