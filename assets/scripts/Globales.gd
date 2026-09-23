class_name Globales

const MaxSpeed = 7.0
const Increment = 30.0
const RotationSpeed = 35.0
const GravityIncrement = 9.81
const Friction = Increment/MaxSpeed

static var MiPersonaje
static var MiLaberinto

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
