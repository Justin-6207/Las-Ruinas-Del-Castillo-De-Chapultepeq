class_name Globales

static var MaxSpeed = 7.0
static var Increment = 30.0
static var RotationSpeed = 35.0
static var GravityIncrement = 9.81
static var Friction = Increment/MaxSpeed
static var DrJohnson

static func rayCast(space_state,Start,End):

	var raycastStart = Start
	var raycastEnd = End

	var parameters = PhysicsRayQueryParameters3D.new()
	parameters.from = raycastStart
	parameters.to = raycastEnd
	parameters.exclude = [DrJohnson]
	parameters.hit_from_inside = true
	
	var result = space_state.intersect_ray(parameters)
	return result
