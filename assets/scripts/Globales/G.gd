class_name G

static var MiPersonaje
static var MisInteraccionables 
static var Camara
static var LlavesTotales 
static var Anunciante
static var Tutorial

static var MisEnemigos
static var PathfindObject

static var LaberintoArray
static var EspaciosVaciosLaberintoArray
static var LaberintoFisico

static var InicioLaberintoJugador
static var FinalLaberinto

static func limpiarCache():
	MiPersonaje = null
	MisInteraccionables = null
	Camara = null
	LlavesTotales = null
	Anunciante = null
	Tutorial = false
	
	MisEnemigos = null
	PathfindObject = null
	
	LaberintoArray = null
	EspaciosVaciosLaberintoArray = null
	LaberintoFisico = null
	
	
	FinalLaberinto = null
	InicioLaberintoJugador = null

static func pisoVacioAleatorio():
	var pisoAleatorioArray = G.EspaciosVaciosLaberintoArray.pick_random()
	return G.LaberintoFisico[pisoAleatorioArray[0]][pisoAleatorioArray[1]]

static func objectCast(Objeto : Node3D,Direccion : Vector3):
	if Objeto == null:
		return {}
		
	var raycastStart = Objeto.global_position
	var raycastEnd = Objeto.global_position + Direccion
	var world3D = Objeto.get_world_3d()
	
	if world3D == null:
		return  {}
	
	var space_state = world3D.direct_space_state
	
	var parameters = PhysicsRayQueryParameters3D.new()
	parameters.from = raycastStart
	parameters.to = raycastEnd
	parameters.exclude = [Objeto,MiPersonaje]
	parameters.hit_from_inside = true
	
	var result = space_state.intersect_ray(parameters)
	return result

static func rayCast(space_state,Start,End):
	var raycastStart = Start
	var raycastEnd = End

	var parameters = PhysicsRayQueryParameters3D.new()
	parameters.from = raycastStart
	parameters.to = raycastEnd
	parameters.exclude = [MiPersonaje]
	parameters.hit_from_inside = true
	
	var result = space_state.intersect_ray(parameters)
	return result

static func setPosArray(Objeto : Node3D):
	if Objeto == null or LaberintoArray == null or G.FinalLaberinto == null:
		return
		
	var resultado = objectCast(Objeto,-Vector3.UP * 10)

	if not resultado.is_empty():
		var objetoColision = resultado.collider
		var padreColision = objetoColision.get_parent().get_parent()
		var posArray = padreColision.get_meta("PosicionArray")
		
		var tampf = G.FinalLaberinto.global_transform.basis.get_scale() * .5
		tampf = Vector3(tampf.x,0,tampf.z)
		
		var origen = Vector3(-tampf.x,0,-tampf.z)
		var posicionFinal = G.FinalLaberinto.global_position
		posicionFinal += Vector3(tampf.x,0,tampf.z)
		
		
		var diferenciaOrigen = ((posicionFinal - origen) * Vector3(1,0,1))
		var diferencia = ((posicionFinal - Objeto.global_position) * Vector3(1,0,1))
		
		var x = (1-((diferencia.x/diferenciaOrigen.x))) * (LaberintoArray.size())
		var y = (1-((diferencia.z/diferenciaOrigen.z))) * (LaberintoArray.size())
		
		Objeto.set_meta("PosicionArrayEstimada",[y,x])
		
		if posArray:
			Objeto.set_meta("PosicionArray",[posArray[0],posArray[1]])
	

####################################################################################

static func dirCam(posicion):
	return ((Camara.global_position-posicion) * Vector3(1,0,1)).normalized()

static func basisCam(posicion):
	var DC = dirCam(posicion)
	var BasisNueva = Basis.looking_at(-DC)
	return BasisNueva

static func rotJug():
	var look = MiPersonaje.global_basis.z
	var sample = Vector3.FORWARD
	var right = Vector3.RIGHT
	
	var pp = look.dot(sample)
	var angulo = acos(look.dot(sample))
	angulo = rad_to_deg(angulo)
	
	if (look.dot(right) < look.dot(-right)):
		angulo = -angulo
	
	return angulo
	
