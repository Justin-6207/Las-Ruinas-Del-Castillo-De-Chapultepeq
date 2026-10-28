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
	global_basis = G.basisCam(global_position)

	if ObjetoContenido != "":
		scale = invObj[ObjetoContenido].proporcion
		SpriteObjeto.texture  = load(invObj[ObjetoContenido].icono)
	else:
		SpriteObjeto.texture = null	
		
