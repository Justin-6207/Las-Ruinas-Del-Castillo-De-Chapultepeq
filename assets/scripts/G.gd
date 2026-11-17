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
static var EsquinaLaberinto

const ObjetosGenerables = ["Espada"]
const ObjetosData = {
	"Espada" : {
		"icono" : "res://assets/imagenes/objetos/espada.png",
		"proporcion" : Vector3(.1,.1,.1)
	},
	"Llave" : {
		"icono" : "res://assets/imagenes/objetos/llave.jpg",
		"proporcion" : Vector3(.1,.1,.1) * .5
	},
	"Salida" : {
		"icono" : "res://assets/imagenes/objetos/Salida.jpg",
		"proporcion" : Vector3(.1,.1,.1) * 2.5
	}
}

const EnemigosData = {
	"Vicente_Suarez" : {
		"icono" : "res://assets/imagenes/enemigos/VicenteSuarez.png",
		"proporcion" : Vector3(.1,.1,.1) * 3
	}
}

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
	EsquinaLaberinto = null

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
	if Objeto == null or LaberintoArray == null or G.EsquinaLaberinto == null:
		return
		
	var resultado = objectCast(Objeto,-Vector3.UP * 10)

	if not resultado.is_empty():
		var objetoColision = resultado.collider
		var padreColision = objetoColision.get_parent().get_parent()
		var posArray = padreColision.get_meta("PosicionArray")
		
		var posicionFinal = G.EsquinaLaberinto.global_position
		var diferenciaOrigen = ((posicionFinal - Vector3(0,0,0)) * Vector3(1,0,1))
		var diferencia = ((posicionFinal - Objeto.global_position) * Vector3(1,0,1))
		
		var x = (1-((diferencia.x/diferenciaOrigen.x))) * (LaberintoArray.size())
		var y = (1-((diferencia.z/diferenciaOrigen.z))) * (LaberintoArray.size())
		
		Objeto.posicionArrayEstimada = [y,x]
		
		if posArray:
			Objeto.posicionArray = [posArray[0],posArray[1]]
	

####################################################################################

static func magCam(posicion):
	return (Camara.global_position-posicion).length()

static func dirCam(posicion):
	return ((Camara.global_position-posicion) * Vector3(1,0,1)).normalized()

static func basisCam(posicion):
	var DC = dirCam(posicion)
	var BasisNueva = Basis.looking_at(-DC)
	return BasisNueva
	
####################################################################################

static func dirJug(posicion):
	return ((MiPersonaje.global_position-posicion) * Vector3(1,0,1))
	
