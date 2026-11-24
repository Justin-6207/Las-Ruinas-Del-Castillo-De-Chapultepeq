extends Node3D

var movimientoAnterior = Vector3.ZERO
var direccionMovimiento = Vector3(0,0,1)

@export var stunned = 0
@export var tipoEnemigo: String
@onready var SpriteObjeto = $"SpriteObjeto"
@onready var ContenedorSonidos = $"Sonidos"

var EnemigosData = GameData.Enemigos
var velocidad = 3.5

var generandoCamino = false
var tocandoMeta = false
var metaLlegada = false
var jugadorVisible = false

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
		tocandoMeta = true
	else:
		tocandoMeta = false
		
	G.setPosArray(self)
	global_basis = G.basisCam(global_position)
	
	if tipoEnemigo != "":
		scale = EnemigosData[tipoEnemigo].proporcion
		SpriteObjeto.texture  = load(EnemigosData[tipoEnemigo].icono)
	
	var distancia = 999999
	var direccionElegida
	
	var dirMeta = ((meta.global_position-global_position) * Vector3(1,0,1))
	var casteoMeta = G.objectCast(self,dirMeta)
	
	var dirJugador = ((G.MiPersonaje.global_position-global_position) * Vector3(1,0,1))
	var casteoJugador = G.objectCast(self,dirJugador)
	
	if casteoJugador != null and casteoJugador.is_empty():
		jugadorVisible = true
	else:
		jugadorVisible = false
	
	if casteoMeta != null and casteoMeta.is_empty() and meta == G.MiPersonaje:
		metaLlegada = true
		caminoASeguir = null
		direccionElegida = dirMeta.normalized()
	else:
		if caminoASeguir == null and generandoCamino == false:
			generandoCamino = true
			
			var miPosArr = self.get_meta("PosicionArray")
			var posArr = meta.get_meta("PosicionArray")
			
			var inicio = G.PathfindObject.genKey(miPosArr[0],miPosArr[1])
			var fin = G.PathfindObject.genKey(posArr[0],posArr[1])
			
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
				metaLlegada = true
				caminoASeguir = null
				
	if direccionElegida:
		var casteoDE = G.objectCast(self,direccionElegida.normalized())
		
		if not casteoDE.is_empty():
			var nodoPrincipal = casteoDE.collider.get_parent().get_parent()
			var condicion1 = (nodoPrincipal.get_meta("Puerta") and nodoPrincipal.Abierta == false)
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
		
