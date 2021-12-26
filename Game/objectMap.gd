extends Node2D

var textures={
	"CHEST":preload("res://sprites/objects_map/chest.png"),\
	"ALTAR":preload("res://sprites/objects_map/altar.png"),\
	"ALTAR_ROTO":preload("res://sprites/objects_map/altar_roto.png"),\
	"FUENTE":preload("res://sprites/objects_map/fuente.png"),\
	"FUENTE_ROTO":preload("res://sprites/objects_map/fuente_rota.png"),\
	"CARTEL":preload("res://sprites/objects_map/cartel.png") }

onready var TILEABLE = preload('res://Class/Tileable.gd').new(self,"OBJECTS")
var type_object="NONE"
var data={}
var items=[]

func set_type(type):
	type_object=type
	$Sprite.set_texture( textures[type_object] )
	if type_object=="ALTAR": create_altar_packs()

func set_texture_img(textureName):
	$Sprite.set_texture(textures[textureName])

func on_activate(own):
	if type_object=="CHEST":
		own.setState("MENU")
		own.menu.showRootMenu(own,"MenuITEMS")
		Globals.SoundsManager.play_sfx("Chest")
		own.ATTRIBUTABLE.set_attr(".stp",1)
	elif type_object=="ALTAR":
		own.setState("MENU")
		own.menu.showRootMenu(own,"MenuUPG")
		Globals.SoundsManager.play_sfx("Chest")
	elif type_object=="FUENTE":
		own.setState("MENU")
		own.menu.showRootMenu(own,"Menu_prg_HEAL")
		Globals.SoundsManager.play_sfx("Chest")
	elif type_object=="CARTEL":
		if data.has("text"): Globals.DialogsManager.diag(data["text"])
		if data.get("isOnly")==true: quit_to_map()

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
	else:        return {"type":"ATTR","elem":"pp","cnt":2}

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

func quit_to_map():
	Globals.TilemapManager.remove_to_tilegroup(self,"OBJECTS")
	get_parent().remove_child(self)
	queue_free()
