extends Node3D

var movimientoAnterior = Vector3.ZERO
var direccionMovimiento = Vector3(0,0,1)

@export var stunned = 0
@export var posicionArray = [1,1]
@export var tipoEnemigo: String
@onready var SpriteObjeto = $"SpriteObjeto"
@onready var ContenedorSonidos = $"Sonidos"

var EnemigosData = G.EnemigosData
var velocidad = 3.25
var abriendoPuerta = 0
var generandoCamino = false
var rompiendoPuerta = false
var caminoASeguir 

var sonidos = {}
func _ready():
	for sonido in ContenedorSonidos.get_children():
		sonidos[sonido.name] = sonido

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var isStunned = false
	
	if stunned > 0:
		stunned -= delta
		isStunned = true 
	
	var cond1 = (((global_position - G.MiPersonaje.global_position) * Vector3(1,0,1)).length() <= 0.5)
	if cond1 and not isStunned:
		get_tree().change_scene_to_file("res://escenas/Inicio.tscn")
		
	G.setPosArray(self)
	global_basis = G.basisCam(global_position)
	if tipoEnemigo != "":
		scale = EnemigosData[tipoEnemigo].proporcion
		SpriteObjeto.texture  = load(EnemigosData[tipoEnemigo].icono)
	
	var distancia = 999999
	var direccionElegida
	
	var dirJug = G.dirJug(global_position)
	var casteoCaracter = G.objectCast(self,dirJug)

	if casteoCaracter != null and casteoCaracter.is_empty():
		caminoASeguir = null
		direccionElegida = dirJug.normalized()
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
			
			if condicion1 and condicion2:
				rompiendoPuerta = true
				sonidos["RompiendoPuerta"].play()
				await get_tree().create_timer(2.0).timeout
				nodoPrincipal.usar()
				rompiendoPuerta = false
				abriendoPuerta = 0

		
		if (not isStunned) and not rompiendoPuerta:
			movimientoAnterior = direccionElegida
			global_position += direccionElegida * delta * velocidad
		
