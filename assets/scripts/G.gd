class_name G

const RotationSpeed = 35.0

static var MiInventario
static var MiPersonaje
static var Camara
static var MisInteraccionables = [] 

const Objetos = {
	"Espada" : {
		"icono" : "res://assets/imagenes/espada.png",
		"costo" : 3
	}
}

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
