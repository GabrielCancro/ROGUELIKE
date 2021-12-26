class_name DDCore

func attack(atk,def): #grid is array[x][y] or array[Vector2]
	var vATK=atk.ATTRIBUTABLE.get_attr("atk")
	var vDAN=atk.ATTRIBUTABLE.get_attr("dan")
	var vDEF=1
	if def.get("ATTRIBUTABLE"): vDEF=def.ATTRIBUTABLE.get_attr("def")
	var DAN_EXT=0
	var rnd=Globals.rndi(1,100)
	Globals.GUI.add_info_concat(atk.visual_name+" ataca a "+def.visual_name)
	Globals.GUI.add_info_concat("   "+str(60+(vATK-vDEF)*5)+"%   ")
	
	if def.get("ABILITYABLE"):
		var ESQ=def.ABILITYABLE.get_full_hab("ESQUIVA")
		if ESQ>0 and Globals.rndi(1,100)<ESQ*10:
			Globals.effectManager.text_effect(def.position,'esquiva')
			Globals.SoundsManager.play_sfx("Miss")
			Globals.GUI.add_info_concat("   ESQUIVA!")
			Globals.GUI.add_info_line()
			return
			
		var BSK=def.ABILITYABLE.get_full_hab("BERSERK")
		if BSK>0 and Globals.rndi(1,100)<30:
			DAN_EXT=DAN_EXT+1
			Globals.GUI.add_info_concat("  (berserk)")
		
		var ETE=def.ABILITYABLE.get_full_hab("ETEREO")
		if ETE>0:
			DAN_EXT=DAN_EXT-3
			Globals.GUI.add_info_concat("  (etereo)")
			
	if atk.get("ABILITYABLE"):
		var BSK=atk.ABILITYABLE.get_full_hab("BERSERK")
		if BSK>0: DAN_EXT=DAN_EXT+1
		
		var RBV=atk.ABILITYABLE.get_full_hab("ROBAVIDA")
		if RBV>0 and Globals.rndi(1,100)<5+RBV*5:
			Globals.effectManager.custom_text_effect(atk.position+Vector2(0,-30),"LIFE","++HP!")
			atk.ATTRIBUTABLE.add_attr(".hp",1)

	if rnd>60+(vATK-vDEF)*5: 
		Globals.effectManager.text_effect(def.position,'miss')
		Globals.SoundsManager.play_sfx("Miss")
		Globals.GUI.add_info_concat("   FALLO")
	else:
		var DAM=Globals.rndi(1,vDAN)+DAN_EXT
		DAM=max(DAM,1)
		Globals.effectManager.sheet_fx("SLASH",def.position)
		aplicar_resultado_ataque(DAM,def)
		Globals.GUI.add_info_concat("   EXITO   -"+str(DAM)+"hp")
		#si es venenoso
		if atk.get("ABILITYABLE") and atk.ABILITYABLE.get_full_hab("VENENOSO")>0:
			Globals.effectManager.custom_text_effect(def.position+Vector2(0,-25),"LIFE","*-*")
			Globals.GUI.add_info_concat("  (venenoso)")
			if def.get("STATEABLE"): def.STATEABLE.add_state("ENVENENADO",2)
	Globals.GUI.add_info_line()

func ataque_anonimo(accuracy,power,def):
	var vDEF=1
	if def.get("ATTRIBUTABLE"): vDEF=def.ATTRIBUTABLE.get_attr("def")
	var rnd100=Globals.rndi(1,100)
	Globals.GUI.add_info_concat("Ataque dirigido a "+def.visual_name)
	Globals.GUI.add_info_concat("   atk["+str(power)+"]  "+str(accuracy-vDEF*5)+"%")	
	if rnd100>accuracy-vDEF*5:
		Globals.effectManager.text_effect(def.position,'miss')
		Globals.SoundsManager.play_sfx("Miss")
		Globals.GUI.add_info_concat("   FALLO")
	else:
		var DAM=Globals.rndi(1,floor(power/2) )
		Globals.effectManager.sheet_fx("SLASH",def.position)
		aplicar_resultado_ataque(DAM,def)
		Globals.GUI.add_info_concat("   EXITO   -"+str(DAM)+"hp")
	Globals.GUI.add_info_line()

func ataque_magico(accuracy,power,def):
	var vDEF=1
	if def.get("ATTRIBUTABLE"): vDEF=floor(def.ATTRIBUTABLE.get_attr("def"))
	var rnd100=Globals.rndi(1,100)
	Globals.GUI.add_info_concat("Conjuro dirigido a "+def.visual_name)
	Globals.GUI.add_info_concat("   pow:"+str(power)+"  "+str(accuracy-vDEF*2)+"%")
	
	if rnd100>accuracy-vDEF*2:
		Globals.effectManager.text_effect(def.position,'miss')
		Globals.SoundsManager.play_sfx("Miss")
		Globals.GUI.add_info_concat("   FALLO")
	else:
		var DAM=max(power,1)
		if Globals.rndi(1,100)<40: DAM=max(power-1,1)
		Globals.effectManager.sheet_fx("SLASH",def.position)
		aplicar_resultado_ataque(DAM,def)
		Globals.GUI.add_info_concat("   EXITO   -"+str(DAM)+"hp")
	Globals.GUI.add_info_line()

func aplicar_resultado_ataque(DAM,def):
	var hp=def.ATTRIBUTABLE.add_attr(".hp",-DAM)
	Globals.effectManager.text_effect(def.position,get_desc_danio(def))
	Globals.SoundsManager.play_sfx("Golpe")

func merge_dir(original, anexar):
	for key in anexar:
		original[key] = anexar[key]

func to_roman(NUM):
	match int(NUM):
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

func no_obstacles_in(var posIni,var posFin) ->bool:
	#Funcion que retorna true si no hay elementos en medio de posIni y posFin de lo contrario retorna false
	var dy=posFin.y-posIni.y
	var dx=posFin.x-posIni.x
	var posAnterior=Vector2()
	var salto=Vector2(0,0)
	var dist_max=max( abs(dx) , abs(dy) )
	#Vamos a tratar los "saltos" de distancias minimas para verificar que todas las casillas necesarias esten libres
	salto.x=float(dx)/dist_max
	salto.y=float(dy)/dist_max
	#Verificamos si la primera posicion es valida (ya que en el ciclo no se revisara esta posicion)
	if Globals.dunGen.isOcluder(posIni.x,posIni.y): return false
	#para recorrer las casillas que estan en nuestra trayectoria usamos el siguiente while
	#Siempre se redondeara a enteros para que la funcion isOcluder sea precisa
	while true:
		#Para ver la posicion anterior
		posAnterior=posIni
		#Redondeamos
		posAnterior.x=int(posAnterior.x)
		posAnterior.y=int(posAnterior.y)
		#Aumentamos la posicion inicial en un "salto"
		posIni.x+=salto.x
		posIni.y+=salto.y
		#Si cambio en posicion en x e y verificaremos las dos casillas adyacentes de la nueva posicon desde donde venia anteriormente la flecha
		if(int(posIni.x)!=posAnterior.x and int(posIni.y)!=posAnterior.y):
			if Globals.dunGen.isOcluder(posAnterior.x,int(posIni.y)): return false
			if Globals.dunGen.isOcluder(int(posIni.x),posAnterior.y): return false
		#Ahora revisamos la nueva posicion
		if Globals.dunGen.isOcluder(int(posIni.x),int(posIni.y)): return false
		#Ahora revisamos si ya revisamos la ultima casilla necesaria (si es haci salimos el ciclo)
		if (int(posIni.x)==posFin.x and int(posIni.y)==posFin.y): break
	#No se encontro ninguna posicion obstruida
	return true
