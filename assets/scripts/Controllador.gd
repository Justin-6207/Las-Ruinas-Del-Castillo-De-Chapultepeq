extends CharacterBody3D

@onready var camera = $"../Camera3D"

var CurrentSpeed = Vector3(0,0,0)
var VelocidadDaño = Vector3(0,0,0)
var CurrentGravitySpeed = Vector3(0,0,0)

var Direccion = Vector3(0,0,0)

var look = Vector3(0,0,0)
var right = Vector3(0,0,0)
var upVector = Vector3(0, 1, 0)

var CamHeight = Vector3(0,2.5,0)

func ManejarMovimiento(delta):
	
	var directionX = 0
	var directionY = 0
	
	if Input.is_action_just_pressed("ui_left"):
		directionX = -1.
	elif Input.is_action_just_pressed("ui_right"):
		directionX = 1.0
	elif Input.is_action_pressed("ui_up"):
		directionY = -1.0
	elif Input.is_action_pressed("ui_down"):
		directionY = 1.0
	
	print(directionX)
	print(directionY)
	var TrueIncrement = Globales.Increment
	Direccion = Vector3(-directionX,0,-directionY)

	CurrentSpeed = CurrentSpeed + (Direccion * TrueIncrement * delta)
	CurrentSpeed = CurrentSpeed - (CurrentSpeed * Globales.Friction * delta)

	velocity = CurrentSpeed

func ManejarGravedad(delta):
	velocity += CurrentGravitySpeed
	if (not  is_on_floor()):
		CurrentGravitySpeed -= (Vector3.UP * 9.81 * delta) 	
	else:
		CurrentGravitySpeed = Vector3(0,0,0)

func ManejarRotacion(delta):
	look = global_basis.z
	right = global_basis.x
	
	var blend = 1.0 - (pow(0.5,delta * Globales.RotationSpeed))

	var lookVector = CurrentSpeed.normalized()
	if (lookVector.length() <= 0):
		lookVector = global_basis.z
		
	var rightVector = upVector.cross(lookVector)
	var correctedLook = upVector.cross(rightVector)
	
	var TargetBasis = Basis(rightVector, upVector, -correctedLook)
	var newBasis = global_basis.slerp(TargetBasis,blend)
	global_basis = newBasis;


func ManejarCamara(delta):
	var blend = 1.0 - (pow(0.5,delta * Globales.RotationSpeed))
	var newCamPos = global_position - Vector3(0,0,2) + CamHeight
	var blendedPosition = camera.position + (newCamPos - camera.position) * blend

	var result = Globales.rayCast(get_world_3d().direct_space_state,global_position + CamHeight, blendedPosition)
	
	if (result):
		camera.position = result.position
	else:
		camera.position = blendedPosition

func _ready():
	Globales.DrJohnson = self

func _physics_process(delta):
	ManejarMovimiento(delta)
	ManejarGravedad(delta)
	ManejarRotacion(delta)
	ManejarCamara(delta)
	move_and_slide()
	
