extends CharacterBody3D

@onready var camera = $"../Camera3D"

var CurrentSpeed = Vector3(0,0,0)
var VelocidadDaño = Vector3(0,0,0)
var CurrentGravitySpeed = Vector3(0,0,0)

var Direction = Vector3(0,0,0)
var upVector = Vector3(0, 1, 0)
var CamHeight = Vector3(0,2.5,0)

var current_mouse_position = Vector2(0,0)
var last_mouse_position = Vector2(0,0)

func ManejarMovimiento(delta):
	
	var directionX = 0
	var directionY = 0
	
	if Input.is_action_pressed("ui_left"):
		directionX = -1.0
	elif Input.is_action_pressed("ui_right"):
		directionX = 1.0
	
	if Input.is_action_pressed("ui_up"):
		directionY = -1.0
	elif Input.is_action_pressed("ui_down"):
		directionY = 1.0

	var TrueIncrement = Globales.Increment
	Direction = Vector3(-directionX,0,-directionY)

	CurrentSpeed = CurrentSpeed + (Direction * TrueIncrement * delta)
	CurrentSpeed = CurrentSpeed - (CurrentSpeed * Globales.Friction * delta)

	velocity = CurrentSpeed

func ManejarGravedad(delta):
	velocity += CurrentGravitySpeed
	if (not  is_on_floor()):
		CurrentGravitySpeed -= (Vector3.UP * 9.81 * delta) 	
	else:
		CurrentGravitySpeed = Vector3(0,0,0)



func ManejarCamara(delta):

	#var result = Globales.rayCast(get_world_3d().direct_space_state,global_position + CamHeight, blendedPosition)
	
	var blend = 1.0 - (pow(0.5,delta * Globales.RotationSpeed))
	var current_mouse_position = get_viewport().get_mouse_position()
	var mouse_motion = (current_mouse_position - last_mouse_position).normalized()
	
	last_mouse_position = current_mouse_position

	var lookVector = Vector3(mouse_motion.x,mouse_motion.y,0)
	var rightVector = upVector.cross(lookVector)
	var correctedLook = upVector.cross(rightVector)
	var newBasis = Basis(rightVector, upVector, -correctedLook)
	
	global_basis = global_basis.slerp(newBasis,blend)
	camera.global_basis = newBasis
	camera.global_position = global_position

func _ready():
	Globales.DrJohnson = self

func _physics_process(delta):
	ManejarMovimiento(delta)
	ManejarGravedad(delta)
	ManejarCamara(delta)
	move_and_slide()
	
