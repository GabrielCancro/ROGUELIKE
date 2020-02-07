extends Node2D

var enemyObject = preload("res://Nodes/Enemy.tscn")
var text_skeleton = preload("res://sprites/enemies/en_skeleton.png")

func create_enemy(type,pos):
	#si ya existe un enemigo en esa posicion retorna falso
	if Globals.TilemapManager.get_element(pos,"ENEMIES"): return false
	
	var EN=enemyObject.instance()
	add_child(EN)
	EN.TILEABLE.set_tile_pos(pos)	
	if type=="SKELETON":
		EN.get_node("Sprite").set_texture(text_skeleton)
		EN.ATTRIBUTABLE.set_attr("hp",4)
		EN.ATTRIBUTABLE.set_attr(".hp",4)
		EN.ATTRIBUTABLE.set_attr("atk",1)
		EN.ATTRIBUTABLE.set_attr("stp",5)
		EN.ATTRIBUTABLE.set_attr("def",1)
		
	return true
		#var baseAttr={"hp":7, "atk":3, "def":1, "dan":2, "end":1, "pp":3, "pow":0, "res":0, "see":5 }