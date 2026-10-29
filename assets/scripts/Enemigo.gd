extends Node3D

var movimientoAnterior = Vector3.ZERO
var direccionMovimiento = Vector3(0,0,1)

@export var posicionArray = [1,1]
@export var tipoEnemigo: String
@onready var SpriteObjeto = $"SpriteObjeto"

var enemigos = G.Enemigos
var velocidad = 3.5
var caminoASeguir 
var generandoCamino = false

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_basis = G.basisCam(global_position)
	if tipoEnemigo != "":
		scale = enemigos[tipoEnemigo].proporcion
		SpriteObjeto.texture  = load(enemigos[tipoEnemigo].icono)
	
	var distancia = 999999
	var direccionElegida
	
	var dirJug = G.dirJug(global_position)
	var casteoCaracter = G.objectCast(self,dirJug)

	
	if casteoCaracter.is_empty():
		caminoASeguir = null
		direccionElegida = dirJug.normalized()
	else:
		if caminoASeguir == null and generandoCamino == false:
			generandoCamino = true
			
			var inicio = G.PathfindObject.genKey(posicionArray[0],posicionArray[1])
			var fin = G.PathfindObject.genKey(G.MiPersonaje.posicionArray[0],G.MiPersonaje.posicionArray[1])
			caminoASeguir = G.PathfindObject.encontrarCamino(inicio,fin)
			if caminoASeguir != null:
				caminoASeguir.remove_at(0)
				
			generandoCamino = false
			
		elif generandoCamino == false and caminoASeguir != null:

			if not caminoASeguir.is_empty():
				var direccion = (caminoASeguir[0] * Vector3(1,0,1)) - (global_position * Vector3(1,0,1))
				if direccion.length() <= .15:
					caminoASeguir.remove_at(0)

				direccionElegida = direccion.normalized()
			else:
				caminoASeguir = null
				
	
	if direccionElegida:
		movimientoAnterior = direccionElegida
		global_position += direccionElegida * delta * velocidad
		
