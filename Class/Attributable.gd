class_name Attributable

var own
signal sg_change_attr

var baseAttr={"hp":7, "atk":3, "def":1, "dan":2, "end":1, "pp":3, "pow":0, "res":0, "see":5, "stp":4 }
var objectAttr={}
var nameAttr={}

func _init(_owner):
	own=_owner
	createNamesAttr()
	yield(own.get_tree().create_timer(0.1), "timeout")
	set_attr(".hp",baseAttr["hp"]/2)
	set_attr(".pp",baseAttr["pp"])

func set_attr(attr,cnt):
	baseAttr[attr]=cnt
	emit_signal("sg_change_attr",attr,cnt)

func add_attr(attr,cnt):
	set_attr(attr,baseAttr[attr]+cnt)
	if attr==".hp" and get_attr(".hp")>get_attr("hp"): set_attr(attr,get_attr("hp"))
	elif attr==".pp" and get_attr(".pp")>get_attr("pp"): set_attr(attr,get_attr("pp"))
	return get_attr(attr)

func get_attr(attr):	
	return baseAttr.get(attr,0)+objectAttr.get(attr,0)

func print_all_attr():
	print("--- ATRIBUTOS FULL ---")
	for attr in nameAttr: print( "     "+attr+": "+str(get_attr(attr)) )

func recalculate_object_attr():
	objectAttr={}
	if !own.get("INVENTARIABLE"): return
	for eq in own.INVENTARIABLE.equip:
		if !eq.get("eq"): continue
		
		for attr in eq["attr"]:
			objectAttr[attr]=objectAttr.get(attr,0)+eq["attr"].get(attr)
	print("RECALCULATE")
	emit_signal("sg_change_attr","",0)

func createNamesAttr():
	#{"hp""atk""def"dan"end""pp""pow""res"}
	nameAttr["atk"]="ataque mele"
	nameAttr["def"]="defensa fisica"
	nameAttr["hp"]="puntos de vida"
	nameAttr["pow"]="atk magico"
	nameAttr["res"]="resistir magia"
	nameAttr["pp"]="puntos de poder"
	
	nameAttr["dan"]="danio mele"
	nameAttr["end"]="dureza fisica"
	
	nameAttr["ven"]="resistir veneno"