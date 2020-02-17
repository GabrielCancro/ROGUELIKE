extends Node2D

var img_chest = preload("res://sprites/objects_map/chest.png")
var img_altar = preload("res://sprites/objects_map/altar.png")
var img_altar_roto = preload("res://sprites/objects_map/altar_roto.png")
var img_fuente = preload("res://sprites/objects_map/fuente.png")
var img_fuente_roto = preload("res://sprites/objects_map/fuente_rota.png")

onready var TILEABLE = preload('res://Class/Tileable.gd').new(self,"OBJECTS")
var type_object="NONE"
var items=[]

func set_type(type):
	type_object=type
	if type_object=="CHEST": $Sprite.set_texture(img_chest)
	elif type_object=="ALTAR": $Sprite.set_texture(img_altar)
	elif type_object=="ALTAR_ROTO": $Sprite.set_texture(img_altar_roto)
	elif type_object=="FUENTE": $Sprite.set_texture(img_fuente)
	elif type_object=="FUENTE_ROTO": $Sprite.set_texture(img_fuente_roto)
	
	if type_object=="ALTAR": create_altar_packs()

func create_altar_packs():
	items=[]
	items.append( get_random_attr_pack() )
	items.append( get_random_hab_pack("HAB") )
	items.append( get_random_hab_pack("SPL") )

func get_random_attr_pack():
	var rnd=randi()%100
	if   rnd<25: return {"type":"ATTR","elem":"atk","cnt":1}
	elif rnd<50: return {"type":"ATTR","elem":"def","cnt":1}
	elif rnd<75: return {"type":"ATTR","elem":"hp","cnt":2}
	else:        return {"type":"ATTR","elem":"pp","cnt":1}

func get_random_hab_pack(type="NONE"):
	var all_codes=Globals.HabsManager.array_all_codes
	for i in range(50):
		var code=all_codes[randi()%all_codes.size()]
		if code=="ARQUERIA": continue
		var hab_type=Globals.HabsManager.getHab(code)["type"]
		if type=="SPL" and hab_type!="SPL": continue
		if type=="HAB" and (hab_type!="PAS" and hab_type!="ACT"): continue
		var own_cnt=Globals.player.ABILITYABLE.get_full_hab(code)
		var max_hab=Globals.HabsManager.getHab(code).get("max",1)
		if own_cnt>=max_hab: continue
		if(hab_type=="PAS" or hab_type=="ACT"): hab_type="HAB"
		return {"type":hab_type,"elem":code,"next_cnt":own_cnt+1}
	return get_random_attr_pack()