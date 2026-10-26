extends Node3D

@export var enemigo: String 
@onready var SpriteObjeto = $"SpriteObjeto"

var enemigos = G.Enemigos

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var DireccionHaciaJugador = G.dirCam(global_position)
	global_basis = basis.looking_at(DireccionHaciaJugador)
	scale = Vector3(.1,.05,.1)
	
	if enemigo != "":
		SpriteObjeto.texture  = load(enemigos[enemigo].icono)
		
