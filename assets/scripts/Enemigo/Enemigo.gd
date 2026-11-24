extends Node3D

var movimientoAnterior = Vector3.ZERO
var direccionMovimiento = Vector3(0,0,1)

@export var stunned = 0
@export var tipoEnemigo: String
@onready var SpriteObjeto = $"SpriteObjeto"
@onready var ContenedorSonidos = $"Sonidos"

@export var posicionArray = [1,1]
@export var posicionArrayEstimada = [1,1]

var EnemigosData = GameData.Enemigos
var velocidad = 3.5

var generandoCamino = false
var rompiendoPuerta = false
var tocandoJugador = false

var caminoASeguir 
var meta

var sonidos = {}

func generarIACorrespondiente():
	IA.IABase(self)
		

func _ready():
	while G.MiPersonaje == null:
		await get_tree().process_frame
	meta = G.MiPersonaje
	
	for sonido in ContenedorSonidos.get_children():
		sonidos[sonido.name] = sonido
		
	generarIACorrespondiente()


func _process(delta):
	if not meta:
		return
	

	
	if stunned > 0:
		stunned -= delta
		
	if (stunned <= 0) and (((global_position - meta.global_position) * Vector3(1,0,1)).length() <= 0.5):
		tocandoJugador = true
	else:
		tocandoJugador = false
		
	G.setPosArray(self)
	global_basis = G.basisCam(global_position)
	if tipoEnemigo != "":
		scale = EnemigosData[tipoEnemigo].proporcion
		SpriteObjeto.texture  = load(EnemigosData[tipoEnemigo].icono)
	
	var distancia = 999999
	var direccionElegida
	
	var dirMeta = ((meta.global_position-global_position) * Vector3(1,0,1))
	var casteoMeta = G.objectCast(self,dirMeta)

	if casteoMeta != null and casteoMeta.is_empty():
		caminoASeguir = null
		direccionElegida = dirMeta.normalized()
		
	elif not rompiendoPuerta:
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
		var casteoDE = G.objectCast(self,direccionElegida.normalized())
		
		if not casteoDE.is_empty():
			var nodoPrincipal = casteoDE.collider.get_parent().get_parent()
			var condicion1 = (nodoPrincipal.get_meta("Puerta") and nodoPrincipal.Abierta == false and rompiendoPuerta == false)
			var condicion2 = (nodoPrincipal.global_position - global_position).length() <= 1
			
			if condicion1 and condicion2 and stunned <= 0:
				stunned = 2
				sonidos["RompiendoPuerta"].play()
				await get_tree().create_timer(2.0).timeout
				nodoPrincipal.usar()
				caminoASeguir = null
				generandoCamino = false
		
		if (stunned <= 0):
			movimientoAnterior = direccionElegida
			global_position += direccionElegida * delta * velocidad
		
