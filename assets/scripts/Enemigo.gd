extends Node3D

var movimientoAnterior = Vector3.ZERO
var direccionMovimiento = Vector3(0,0,1)

@export var tipoEnemigo: String 
@onready var SpriteObjeto = $"SpriteObjeto"

var enemigos = G.Enemigos
var distanciaCasteo = 2
var direccionesMovimiento = [
	Vector3(1,0,0),
	Vector3(-1,0,0),
	Vector3(0,0,1),
	Vector3(0,0,-1)
]
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
		direccionElegida = dirJug.normalized()
	else:
		for direccion in direccionesMovimiento:
			if direccion == -movimientoAnterior:
				continue
				
			var casteo = G.objectCast(self,direccion * distanciaCasteo)
			if casteo.is_empty():
				var mag = G.magCam(global_position + direccion)
				if mag < distancia:
					distancia = mag
					direccionElegida = direccion
	
	if direccionElegida:
		movimientoAnterior = direccionElegida
		global_position += direccionElegida * delta * 2
		
