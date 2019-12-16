extends Node2D

var equip=[]
var items=[]
var baseAttr={"hp":7, "atk":3, "def":1, "dan":2, "end":1, "pp":3, "pow":0, "rem":0 }
var nameAttr={}

# Called when the node enters the scene tree for the first time.
func _ready():
	baseAttr[".hp"]=baseAttr["hp"]
	baseAttr[".pp"]=baseAttr["pp"]
	createEquip()
	createItems()
	createNamesAttr()

func createEquip():
	equip.append( {"icon":0, "name": "Espada", "type":"Hand", "desc": "+1atk  -1def"} )
	equip.append( {"icon":1, "name": "Espada Ancha", "type":"Hand", "desc": "+3pp"} )
	equip.append( {"icon":2, "name": "Baculo Magico", "type":"Hand", "desc": "+1atk  -1def"} )
	equip.append( {"icon":3, "name": "Ballesta", "type":"Hand", "desc": "+3pp"} )
	equip.append( {"icon":4, "name": "Yelmo", "type":"Head", "desc": "+1atk  -1def"} )
	equip.append( {"icon":5, "name": "Sombrero Magico","type":"Head", "desc": "+3pp"} )

func createItems():
	items.append( {"icon":12, "name": "Manzana", "cnt":3, "desc": "+2hp"} )
	items.append( {"icon":13, "name": "Carne", "cnt":1, "desc": "+6hp"} )
	items.append( {"icon":14, "name": "Pocion", "cnt":6, "desc": "+5pp"} )
	items.append( {"icon":16, "name": "Elixir Fuerza", "cnt":3, "desc": "+5atk"} )

func createNamesAttr():
	#{"hp""atk""def"dan"end""pp""pow""rem"}
	nameAttr["atk"]="ataque mele"
	nameAttr["def"]="defensa fisica"
	nameAttr["pry"]="atk proyectiles"
	nameAttr["end"]="dureza fisica"
	nameAttr["pow"]="atk magico"
	nameAttr["res"]="resistir magia"
	nameAttr["ot1"]="atributo 1"
	nameAttr["ot2"]="atributo 2"