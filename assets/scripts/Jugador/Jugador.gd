extends CharacterBody3D

@export var elInventario = ["Espada","",""]
var espacioEnLaMano = 0

@export var llavesRecolectadas = 0
@export var stamina = 100
@export var maxStamina = 100
@export var posicionArray = [1,1]

@onready var camera = $"../Camera3D"
@onready var objetoEnLaMano = $"objetoEnLaMano"
@onready var manoIndicadora = $"manoIndicadora"

var Corriendo = false
var directionX = 0
var directionY = 0
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

func UsarObjeto():
	objetoEnLaMano.UsarObjeto(elInventario[espacioEnLaMano])
	elInventario[espacioEnLaMano] = ""

func ManejarInput(delta):
	directionX = 0
	directionY = 0
	
	if Input.is_action_pressed("Movimiento - Izquierda"):
		directionX = -1.0
	elif Input.is_action_pressed("Movimiento - Derecha"):
		directionX = 1.0
	
	if Input.is_action_pressed("Movimiento - Arriba"):
		directionY = -1.0
	elif Input.is_action_pressed("Movimiento - Abajo"):
		directionY = 1.0
	
	if Input.is_action_just_pressed("Click Izquierdo"):
		manoIndicadora.interactuarConObjeto()
		
	if Input.is_action_just_pressed("Usar Objeto"):
		UsarObjeto()

	if Input.is_action_pressed("Correr") and stamina > 0:
		Corriendo = true
		stamina -= delta * 20
	else:
		Corriendo = false
		if directionX == 0 and directionY == 0:
			stamina += delta * 20
	
	stamina = clamp(stamina,0,100)

func ManejarMovimiento(delta):
	var TrueIncrement = Increment
	if Corriendo == false:
		TrueIncrement = TrueIncrement * .5
		
	var basisX = camera.global_basis.x
	var basisZ = camera.global_basis.z
	
	Direction = ((basisX * directionX + basisZ * directionY) * Vector3(1,0,1)).normalized()

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
	var blend = 1.0 - (pow(0.5,delta * G.RotationSpeed))
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

func CamaraTopDown(delta):
	var blend = 1.0 - (pow(0.5,delta * G.RotationSpeed))
	var mouse_motion = Vector2(xMouseMove,yMouseMove) * delta 
	
	xMouseMove = 0
	yMouseMove = 0

	var basisX = camera.global_basis.x
	var basisY = camera.global_basis.y
	var basisZ = camera.global_basis.z
	
	var upAddition = basisY * mouse_motion.y
	var rightAddition = basisX * -mouse_motion.x
	
	var newLook = -(basisZ + upAddition + rightAddition)
	var camBasis = Basis.looking_at(newLook,Vector3.UP)
	var charBasis = Basis.looking_at((-newLook * Vector3(1,0,1)).normalized(),Vector3.UP)
	
	global_basis = global_basis.slerp(charBasis,blend)
	camera.global_basis = camera.global_basis.slerp(camBasis,blend)
	camera.global_position = global_position + Vector3.UP * 5
	
func ManejarInventario(delta):
	objetoEnLaMano.ObjetoContenido = elInventario[espacioEnLaMano]

func _unhandled_input(event):
	var input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if input:
		xMouseMove = event.relative.x
		yMouseMove = event.relative.y

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	G.MiPersonaje = self
	G.Camara = camera

func _physics_process(delta):
	G.setPosArray(self)
	ManejarInput(delta)
	ManejarMovimiento(delta)
	ManejarGravedad(delta)
	#CamaraTopDown(delta)
	ManejarCamara(delta)
	ManejarInventario(delta)
	move_and_slide()
	
