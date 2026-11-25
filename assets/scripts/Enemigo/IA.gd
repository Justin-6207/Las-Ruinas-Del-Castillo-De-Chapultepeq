class_name IA

static func IABase(Enemigo : Node3D):
	if Enemigo.tipoEnemigo == "Nicolas_Bravo":
		Enemigo.sonidos["Estatica"].play()
	elif Enemigo.tipoEnemigo == "Francisco_Marquez":
		Enemigo.velocidad = 7
		Enemigo.meta = G.pisoVacioAleatorio()
		Enemigo.set_meta("Robo",5)
		Enemigo.set_meta("MaxRobo",10)
		
	while is_instance_valid(Enemigo):
		var Tree = Enemigo.get_tree()
		if Tree == null:
			break
		await Tree.process_frame
		var delta = Tree.root.get_process_delta_time()
		
		if Enemigo.tipoEnemigo == "Nicolas_Bravo":
			NicolasBravo(Enemigo)
		elif Enemigo.tipoEnemigo == "Francisco_Marquez":
			FranciscoMarquez(Enemigo,delta)
		
static func NicolasBravo(Enemigo : Node3D):
	if Enemigo.tocandoMeta:
		for i in range(0,G.MiPersonaje.MiInventario.size()):
			var objeto = G.MiPersonaje.MiInventario[i]
			if objeto == "Biblia":
				Enemigo.stunned = 6
				G.MiPersonaje.MiInventario[i] = ""
				Enemigo.sonidos["Hallelujah"].play()
				return
				
		Enemigo.get_tree().change_scene_to_file("res://escenas/GameOver.tscn")
		
static func FranciscoMarquez(Enemigo : Node3D,delta):
	if Enemigo.get_meta("Robo") > 0:
		Enemigo.set_meta("Robo",Enemigo.get_meta("Robo") - delta)
	
	var cond1 = (Enemigo.get_meta("Robo") > 0 and Enemigo.meta == G.MiPersonaje)
	var cond2 = (Enemigo.metaLlegada and Enemigo.meta != G.MiPersonaje)
	
	if Enemigo.get_meta("Robo") <= 0 and Enemigo.meta != G.MiPersonaje:
		Enemigo.meta = G.MiPersonaje
		Enemigo.caminoASeguir = null
		Enemigo.metaLlegada = false
		
	elif cond1 or cond2:
		Enemigo.meta = G.pisoVacioAleatorio()
		Enemigo.caminoASeguir = null
		Enemigo.metaLlegada = false
	
	if Enemigo.stunned > 0:
		Enemigo.set_meta("Robo",Enemigo.get_meta("MaxRobo"))
	
	if Enemigo.tocandoMeta:
		if Enemigo.meta == G.MiPersonaje:
			if Enemigo.get_meta("Robo") <= 0:
				
				Enemigo.global_position = G.pisoVacioAleatorio().global_position + Vector3.UP * 2
				for i in range(0,G.MiPersonaje.MiInventario.size()):
					if G.MiPersonaje.MiInventario[i] != "":
						G.MiPersonaje.MiInventario[i] = ""
					break
				Enemigo.sonidos["Risa"].play()
