extends Node2D

var enemyObject = preload("res://Nodes/Enemy.tscn")
var img_skeleton = preload("res://sprites/enemies/en_skeleton2.png")
var img_trasgo = preload("res://sprites/enemies/en_trasgo.png")
var img_worm = preload("res://sprites/enemies/en_worm.png")
var img_worm_giant = preload("res://sprites/enemies/en_worm_giant.png")

func create_enemy(type,pos):
	#si ya existe un enemigo en esa posicion retorna falso
	if Globals.TilemapManager.get_element(pos,"ENEMIES"): return false	
	var EN=enemyObject.instance()
	add_child(EN)	
	EN.TILEABLE.set_tile_pos(pos)
	
	if type=="WORM":
		EN.visual_name="Gusano"
		EN.get_node("Sprite").set_texture(img_worm)
		EN.ATTRIBUTABLE.set_attr("hp",2)
		EN.ATTRIBUTABLE.set_attr(".hp",2)
		EN.ATTRIBUTABLE.set_attr("atk",1)
		EN.ATTRIBUTABLE.set_attr("stp",3)
		EN.ATTRIBUTABLE.set_attr("def",0)
	elif type=="TRASGO":
		EN.visual_name="Trasgo"
		EN.get_node("Sprite").set_texture(img_trasgo)
		EN.ATTRIBUTABLE.set_attr("hp",2)
		EN.ATTRIBUTABLE.set_attr(".hp",2)
		EN.ATTRIBUTABLE.set_attr("atk",1)
		EN.ATTRIBUTABLE.set_attr("stp",6)
		EN.ATTRIBUTABLE.set_attr("def",1)
	elif type=="SKELETON":
		EN.visual_name="Esqueleto"
		EN.get_node("Sprite").set_texture(img_skeleton)
		EN.ATTRIBUTABLE.set_attr("hp",4)
		EN.ATTRIBUTABLE.set_attr(".hp",4)
		EN.ATTRIBUTABLE.set_attr("atk",3)
		EN.ATTRIBUTABLE.set_attr("stp",5)
		EN.ATTRIBUTABLE.set_attr("def",2)
	if type=="WORM_GIANT":
		EN.visual_name="Gusano gigante"
		EN.get_node("Sprite").set_texture(img_worm_giant)
		EN.ATTRIBUTABLE.set_attr("hp",6)
		EN.ATTRIBUTABLE.set_attr(".hp",6)
		EN.ATTRIBUTABLE.set_attr("atk",2)
		EN.ATTRIBUTABLE.set_attr("stp",4)
		EN.ATTRIBUTABLE.set_attr("def",2)
	
		
	return true
		#var baseAttr={"hp":7, "atk":3, "def":1, "dan":2, "end":1, "pp":3, "pow":0, "res":0, "see":5 }
func get_enemyes_by_level(level):
	#return ["TRASGO"]
	match level:
		0: return ["WORM"]
		1: return ["TRASGO"]
		2: return ["SKELETON"]
		3: return ["WORM_GIANT"]
		4: return ["SKELETON"]
		5: return ["SKELETON"]
		_: return ["SKELETON"]

func random_enemy(level: int, pos)->void:
	var type
	var enemysList=[] #Lista de enemigos de level actual
	var randomLevel=randi()%101+1
	if(randomLevel<=5): #posibilidad de que el enemigo sea de nivel-6 es 5%
		enemysList=get_enemyes_by_level(max(0,level-6))
	elif(randomLevel<=10): #posibilidad de que el enemigo sea de nivel-5 es 5%
		enemysList=get_enemyes_by_level(max(0,level-5))
	elif(randomLevel<=15): #posibilidad de que el enemigo sea de nivel-4 es 5%
		enemysList=get_enemyes_by_level(max(0,level-4))
	elif(randomLevel<=25): #posibilidad de que el enemigo sea de nivel-3 es 10%
		enemysList=get_enemyes_by_level(max(0,level-3))
	elif(randomLevel<=40): #posibilidad de que el enemigo sea de nivel-2 es 15%
		enemysList=get_enemyes_by_level(max(0,level-2))
	elif(randomLevel<=60): #posibilidad de que el enemigo sea de nivel-1 es 20%
		enemysList=get_enemyes_by_level(max(0,level-1))
	else: #posibilidad de que el enemigo sea de nivel actual es 40%
		enemysList=get_enemyes_by_level(level)
	type=enemysList[randi()%enemysList.size()]
	create_enemy(type,pos)