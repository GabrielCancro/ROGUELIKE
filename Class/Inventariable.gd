class_name Inventariable

var own

var equip=[]
var items=[]

func _init(_owner):
	own=_owner

func addItem(CODE,cant=1):
	if CODE<200:
		equip.append( Globals.ItemsManager.getItem(CODE) )
	elif CODE<300:
		var adding=true
		for it in items:
			if it["code"]==CODE:
				it["cnt"]+=cant
				adding=false
				break
		if adding: items.append( Globals.ItemsManager.getItem(CODE) )

func change_equipament():
	if own.ATTRIBUTABLE: 
		own.ATTRIBUTABLE.recalculate_object_attr()