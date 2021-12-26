class_name Stateable

var own
signal sg_change_state

# ENVENENADO - INMOVILIZADO
var states={}

func _init(_owner): own=_owner

func set_state(state,cnt):
	if !states.get(state): 
		on_enter_state(state)
	states[state]=cnt
	
	if cnt<=0: states.erase(state)
	emit_signal("sg_change_state")

func add_state(state,cnt): 
	if cnt>get_state(state): set_state(state,cnt)
	elif cnt<0: set_state(state,get_state(state)+cnt)

func get_state(state): return states.get(state,0)

func get_all_states_info():
	var TXT=""
	for st in states: TXT+=st+"  x"+str(get_state(st))+"\n"
	return TXT

func get_all_states_desc():
	var TXT=""
	for st in states: TXT+=desc_state(st)+"\n"
	return TXT

func update_all_states():
	print("UPDATE STATES "+str(states))
	for st in states:
		ejecutar_state(st)
		states[st]=states[st]-1
	for st in states: if states[st]<=0: states.erase(st)
	emit_signal("sg_change_state")

func ejecutar_state(st):
	yield(own.get_tree().create_timer(.5), "timeout")
	if st=="ENVENENADO":
		if Globals.rnd.randi()%100<50:
			own.ATTRIBUTABLE.add_attr(".hp",-1)
			Globals.effectManager.custom_text_effect(own.position+Vector2(0,-25),"LIFE","Veneno -1hp")
			Globals.SoundsManager.play_sfx("Golpe")
			Globals.effectManager.sheet_fx("SLASH",own.position )
		else:
			Globals.effectManager.custom_text_effect(own.position+Vector2(0,-25),"LIFE","Veneno -0hp")

func desc_state(st):
	if st=="ENVENENADO": return "50% chance -1hp por turno"
	elif st=="INMOVILIZADO": return "movilidad muy reducida"

func on_enter_state(st):
	if st=="INMOVILIZADO": own.ATTRIBUTABLE.set_attr(".stp",1)

func clear_all_states():
	for st in states:
		states.erase(st)
