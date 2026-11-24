class_name IA

static func IABase(Enemigo : Node3D):
	if Enemigo.tipoEnemigo == "Nicolas_Bravo":
		Enemigo.sonidos["Estatica"].play()
		
	while is_instance_valid(Enemigo):
		var Tree = Enemigo.get_tree()
		if Tree == null:
			break
		await Tree.process_frame
		
		if Enemigo.tipoEnemigo == "Nicolas_Bravo":
			NicolasBravo(Enemigo)
		
static func NicolasBravo(Enemigo : Node3D):
	if Enemigo.tocandoJugador:
		Enemigo.get_tree().change_scene_to_file("res://escenas/Inicio.tscn")
