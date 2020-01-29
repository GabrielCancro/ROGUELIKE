class_name DDCore

func attack(atk,def): #grid is array[x][y] or array[Vector2]
	var rnd=Globals.rndi(1,100)
	if rnd<5:
		Globals.effectManager.text_effect(atk.position,'miss')
	elif rnd<20:
		Globals.effectManager.text_effect(def.position,'evasion')
	elif rnd<100:
		if def.get("ATTRIBUTABLE"): 
			var vATK=atk.ATTRIBUTABLE.get_attr("atk")
			var vDEF=def.ATTRIBUTABLE.get_attr("def")
			var DAM=Globals.rndi(vATK,vATK*2)-Globals.rndi(vDEF,vDEF*2)
			if DAM<1: DAM=1
			var hp=def.ATTRIBUTABLE.add_attr(".hp",-DAM)
			Globals.effectManager.text_effect(def.position,get_desc_danio(def))
			Globals.effectManager.hit_effect(def.position)
			if hp<=0: def.dead()

func merge_dir(original, anexar):
    for key in anexar:
        original[key] = anexar[key]

func to_roman(NUM):
	match NUM:
		0: return ""
		1: return "I"
		2: return "II"
		3: return "III"
		4: return "IV"
		5: return "V"
		6: return "VI"
		7: return "VII"
		8: return "VIII"
		9: return "IX"
		_: return ""

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