extends Node2D

func attack(tipo, args):
	print(tipo)
	if tipo=="MELEE":
		if attack_melee(args[0],args[1]):
			damage_melee(args[0],args[1])

func attack_melee(atk,def):
	var vATK=atk.ATTRIBUTABLE.get_attr("atk")
	var vDEF=max(1,get_attr(def,"def"))
	Globals.GUI.add_info_concat(atk.visual_name+" ataca a "+def.visual_name)
	Globals.GUI.add_info_concat("   "+str(60+(vATK-vDEF)*5)+"%   ")
	
	var ESQ=get_hab(def,"ESQUIVA")
	if ESQ>0 and Globals.rndi(1,100)<ESQ*10:
		Globals.effectManager.text_effect(def.position,'esquiva')
		Globals.SoundsManager.play_sfx("Miss")
		Globals.GUI.add_info_concat("   ESQUIVA!")
		Globals.GUI.add_info_line()
		return 0
		
	var RBV=get_hab(atk,"ROBAVIDA")
	if RBV>0 and Globals.rndi(1,100)<5+RBV*5:
		Globals.effectManager.custom_text_effect(atk.position+Vector2(0,-30),"LIFE","++HP!")
		atk.ATTRIBUTABLE.add_attr(".hp",1)
	
	var rnd100=Globals.rndi(1,100)
	if Globals.rndi(1,100)>60+(vATK-vDEF)*5: 
		Globals.effectManager.text_effect(def.position,'miss')
		Globals.SoundsManager.play_sfx("Miss")
		Globals.GUI.add_info_concat("   FALLO")
		Globals.GUI.add_info_line()
		return 0
	else:
		var VEN=get_hab(atk,"VENENOSO")
		if VEN>0:
			Globals.effectManager.custom_text_effect(def.position+Vector2(0,-25),"LIFE","*-*")
			Globals.GUI.add_info_concat("  (venenoso)")
			if def.get("STATEABLE"): def.STATEABLE.add_state("ENVENENADO",VEN)
	return 1
	
func damage_melee(atk,def):
	var vDAN=atk.ATTRIBUTABLE.get_attr("dan")
	var DAN_EXT=0
	
	var BSK=get_hab(atk,"BERSERK")
	if BSK>0: DAN_EXT=DAN_EXT+1
	
	BSK=get_hab(def,"BERSERK")
	if BSK>0 and Globals.rndi(1,100)<30:
		DAN_EXT=DAN_EXT+1
		Globals.GUI.add_info_concat("  (berserk)")
		
	var ETE=get_hab(def,"ETEREO")
	if ETE>0: 
		DAN_EXT=-3
		Globals.GUI.add_info_concat("  (etereo)")
	var DAM=Globals.rndi(1,vDAN)+DAN_EXT
	DAM=max(DAM,1)
	Globals.GUI.add_info_line()
	aplicar_damage(DAM,def)

func get_hab(own,nameHab):
	if own.get(nameHab): return own.ABILITYABLE.get_full_hab(nameHab)
	else: return 0;

func get_attr(own,nameAttr):
	if own.get(nameAttr): return own.nameAttr.get_attr(nameAttr)
	else: return 0;

func aplicar_damage(DAM,def):
	Globals.effectManager.sheet_fx("SLASH",def.position)
	var hp=def.ATTRIBUTABLE.add_attr(".hp",-DAM)
	Globals.effectManager.text_effect(def.position,get_desc_danio(def))
	Globals.SoundsManager.play_sfx("Golpe")
	Globals.GUI.add_info_concat("   EXITO   -"+str(DAM)+"hp")
	Globals.GUI.add_info_line()

func get_desc_danio(pj):
	var crtHp:float=pj.ATTRIBUTABLE.get_attr(".hp")
	var maxHp:float=pj.ATTRIBUTABLE.get_attr("hp")
	var pdan:float=float(pj.ATTRIBUTABLE.get_attr(".hp"))/float(pj.ATTRIBUTABLE.get_attr("hp"))

	var txdan=""
	if pdan>=1: txdan="Ileso"
	elif pdan>.8: txdan="Magullado"
	elif pdan>.5: txdan="Lastimado"
	elif pdan>.2: txdan="Herido"
	elif pdan>.1: txdan="Muy Herido"
	elif pdan>0:txdan="Agonizando"
	else: txdan="Muerto"
	return txdan
