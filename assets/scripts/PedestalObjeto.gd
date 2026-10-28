extends Node3D

@export var ObjetoContenido: String 
@onready var SpriteObjeto = $"SpriteObjeto"

var invObj = G.Objetos
var botones = []

func usar():
	if ObjetoContenido == "Llave":
		ObjetoContenido = ""
		G.MiPersonaje.llavesRecolectadas += 1
		queue_free()

func _ready():
	G.MisInteraccionables.push_back(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var DireccionHaciaJugador = G.dirCam(global_position)
	global_basis = Basis.looking_at(DireccionHaciaJugador)

	if ObjetoContenido != "":
		scale = invObj[ObjetoContenido].proporcion
		SpriteObjeto.texture  = load(invObj[ObjetoContenido].icono)
	else:
		SpriteObjeto.texture = null	
		
