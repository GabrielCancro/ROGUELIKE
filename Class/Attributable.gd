class_name Attributable

var own
signal sg_change_attr

var baseAttr={"hp":3, "atk":1, "def":1, "pp":0, "pow":0, "see":5, "stp":4 }
var objectAttr={}
var nameAttr={}

func _init(_owner):
	own=_owner
	createNamesAttr()
	yield(own.get_tree().create_timer(0.1), "timeout")
	set_attr(".hp",baseAttr["hp"])
	set_attr(".pp",baseAttr["pp"])
	set_attr(".stp",baseAttr["stp"])

func set_attr(attr,cnt):
	if cnt<0: cnt=0
	baseAttr[attr]=cnt
	check_excess(attr)
	if attr==".hp" and cnt<=0: own.dead()
	emit_signal("sg_change_attr")

func set_attr_dic(dic):
	for attr in dic:
		set_attr(attr,dic[attr])

func check_excess(attr):
	if (attr==".hp" or attr=="hp") and get_attr(".hp")>get_attr("hp"): set_attr(".hp",get_attr("hp"))
	if (attr==".pp" or attr=="pp") and get_attr(".pp")>get_attr("pp"): set_attr(".pp",get_attr("pp"))
	if (attr==".stp" or attr=="stp") and get_attr(".stp")>get_attr("stp"): set_attr(".stp",get_attr("stp"))

func add_attr(attr,cnt):
	set_attr(attr,baseAttr[attr]+cnt)
	return get_attr(attr)

func get_attr(attr):
	var result=baseAttr.get(attr,0)+objectAttr.get(attr,0)
	if (attr=="stp") and own.get("STATEABLE"):
		if own.STATEABLE.get_state("INMOVILIZADO")>0: result=1
	return result

func print_all_attr():
	print("--- ATRIBUTOS FULL ---")
	for attr in nameAttr: print( "     "+attr+": "+str(get_attr(attr)) )

func recalculate_object_attr():
	objectAttr={}
	if !own.get("INVENTARIABLE"): return
	for eq in own.INVENTARIABLE.equip:
		if !eq.get("eq"): continue
		
		for attr in eq["attr"]:
			check_excess(attr)
			objectAttr[attr]=objectAttr.get(attr,0)+eq["attr"].get(attr)
	print("RECALCULATE")
	emit_signal("sg_change_attr")

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
