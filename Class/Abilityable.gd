class_name Abilityable

var own
#signal sg_change_habs

var baseHabs={}
var objectHabs={}

func _init(_owner):
	own=_owner	
	yield(own.get_tree().create_timer(0.1), "timeout")
	set_base_hab("BERSERK",5)
	set_base_hab("PUNTERIA",3)
	set_base_hab("ARQUERIA",3)
	print_all_habs()

func print_all_habs():
	print("--- HABILIDADES FULL ---")
	var fullHabs=get_all_habs()
	for h in fullHabs: print( "     "+h+": "+str(fullHabs[h]) )

func get_full_hab(CODE_HAB):
	recalculate_object_habs()
	return baseHabs.get(CODE_HAB,0)+objectHabs.get(CODE_HAB,0)

func get_all_habs():
	recalculate_object_habs()
	var fullHabs={}
	for h in baseHabs:
		fullHabs[h]=fullHabs.get(h,0)+baseHabs[h]
	for h in objectHabs:
		fullHabs[h]=fullHabs.get(h,0)+objectHabs[h]		
	return fullHabs

func set_base_hab(CODE_HAB,cnt=0):
	baseHabs[CODE_HAB]=cnt

func add_base_hab(CODE_HAB,cnt):
	set_base_hab(CODE_HAB,baseHabs.get(CODE_HAB,0)+cnt) 

func recalculate_object_habs():
	objectHabs={}
	if !own.get("INVENTARIABLE"): return
	for eq in own.INVENTARIABLE.equip:
		if !eq.get("eq"): continue
		
		var CODE_HAB=eq.get("code_hab_1",null)
		if CODE_HAB: objectHabs[CODE_HAB]=objectHabs.get(CODE_HAB,0)+eq.get("cnt_hab_1",0)
		
		CODE_HAB=eq.get("code_hab_2",null)
		if CODE_HAB: objectHabs[CODE_HAB]=objectHabs.get(CODE_HAB,0)+eq.get("cnt_hab_2",0)
