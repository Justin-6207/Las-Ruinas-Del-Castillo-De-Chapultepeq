extends CharacterBody3D

@onready var camera = $"../Camera3D"
@onready var SpriteOBJ3D = $"SpriteOBJ3D"
@export var miInventario = ["Espada","",""]
var espacioEnLaMano = 0
var invObj = Globales.Objetos



var CurrentSpeed = Vector3(0,0,0)
var CurrentGravitySpeed = Vector3(0,0,0)

var Direction = Vector3(0,0,0)
var upVector = Vector3(0, 1, 0)

var xMouseMove : float
var yMouseMove : float

static var MaxSpeed = 7.0
static var Increment = 30.0
static var RotationSpeed = 35.0
static var GravityIncrement = 9.81
static var Friction = Increment/MaxSpeed

###############################################################################################

func ManejarMovimiento(delta):
	var directionX = 0
	var directionY = 0
	
	if Input.is_action_pressed("Movimiento - Izquierda"):
		directionX = -1.0
	elif Input.is_action_pressed("Movimiento - Derecha"):
		directionX = 1.0
	
	if Input.is_action_pressed("Movimiento - Arriba"):
		directionY = -1.0
	elif Input.is_action_pressed("Movimiento - Abajo"):
		directionY = 1.0

	var TrueIncrement = Increment
	
	var basisX = camera.global_basis.x
	var basisZ = camera.global_basis.z
	
	Direction = (basisX * directionX + basisZ * directionY).normalized()

	CurrentSpeed = CurrentSpeed + (Direction * TrueIncrement * delta)
	CurrentSpeed = CurrentSpeed - (CurrentSpeed * Friction * delta)

	velocity = CurrentSpeed

func ManejarGravedad(delta):
	velocity += CurrentGravitySpeed
	if (not is_on_floor()):
		CurrentGravitySpeed -= (Vector3.UP * 9.81 * delta) 	
	else:
		CurrentGravitySpeed = Vector3(0,0,0)

func ManejarCamara(delta):
	#var result = Globales.rayCast(get_world_3d().direct_space_state,global_position + CamHeight, blendedPosition)
	var blend = 1.0 - (pow(0.5,delta * Globales.RotationSpeed))
	var mouse_motion = Vector2(xMouseMove,yMouseMove) * delta 
	
	xMouseMove = 0
	yMouseMove = 0

	var basisX = camera.global_basis.x
	var basisY = camera.global_basis.y
	var basisZ = camera.global_basis.z
	
	var upAddition = basisY * mouse_motion.y
	var rightAddition = basisX * -mouse_motion.x
	
	var newLook = -(basisZ + upAddition + rightAddition)
	newLook = (newLook * Vector3(1,0,1)).normalized()

	var camBasis = Basis.looking_at(newLook,Vector3.UP)
	var charBasis = Basis.looking_at(-newLook,Vector3.UP)
	
	global_basis = global_basis.slerp(charBasis,blend)
	camera.global_basis = camera.global_basis.slerp(camBasis,blend)
	camera.global_position = global_position + Vector3.UP

func ManejarInventario(delta):
	var objetoStr = miInventario[espacioEnLaMano]
	if objetoStr == "":
		SpriteOBJ3D.texture = null
	else:
		SpriteOBJ3D.texture = load(invObj[objetoStr].icono)
		pass
###############################################################################################

func _unhandled_input(event):
	var input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if input:
		xMouseMove = event.relative.x
		yMouseMove = event.relative.y

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Globales.MiPersonaje = self

func _physics_process(delta):
	ManejarMovimiento(delta)
	ManejarGravedad(delta)
	ManejarCamara(delta)
	ManejarInventario(delta)
	move_and_slide()
	
