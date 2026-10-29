class_name G

const RotationSpeed = 35.0

static var MiInventario
static var MiPersonaje
static var Camara
static var PathfindObject
static var MisInteraccionables = [] 

const DataObjetos = {
	"Espada" : {
		"icono" : "res://assets/imagenes/espada.png",
		"proporcion" : Vector3(.1,.05,.1)
	},
	"Llave" : {
		"icono" : "res://assets/imagenes/llave.jpg",
		"proporcion" : Vector3(.1,.05,.1) * .5
	},
}

const Enemigos = {
	"Vicente_Suarez" : {
		"icono" : "res://assets/imagenes/VicenteSuarez.png",
		"proporcion" : Vector3(.1,.05,.1) * 3
	}
}

static func objectCast(Objeto : Node3D,Direccion : Vector3):
	var raycastStart = Objeto.global_position
	var raycastEnd = Objeto.global_position + Direccion
	var space_state = Objeto.get_world_3d().direct_space_state
	
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
	var resultado = objectCast(Objeto,-Vector3.UP * 10)
	if not resultado.is_empty():
		var objetoColision = resultado.collider
		var posArray = objetoColision.get_meta("PosicionArray")
		if posArray:
			Objeto.posicionArray = [posArray[0],posArray[1]]
	
static func magCam(posicion):
	return (Camara.global_position-posicion).length()

static func dirJug(posicion):
	return ((MiPersonaje.global_position-posicion) * Vector3(1,0,1))
	
static func dirCam(posicion):
	return ((Camara.global_position-posicion) * Vector3(1,0,1)).normalized()

static func basisCam(posicion):
	var DC = dirCam(posicion)
	var BasisNueva = Basis.looking_at(DC)
	return BasisNueva
