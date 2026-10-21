extends Node3D

@export var ObjetoContenido: String 
@onready var SpriteObjeto = $"SpriteObjeto"

var invObj = G.Objetos
var botones = []

func usar():
	ObjetoContenido = ""

func _ready():
	G.MisInteraccionables.push_back(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var DireccionHaciaJugador = (G.Camara.global_position-global_position).normalized()
	global_basis = basis.looking_at(DireccionHaciaJugador)
	scale = Vector3(.1,.05,.1)
	
	if ObjetoContenido != "":
		SpriteObjeto.texture  = load(invObj[ObjetoContenido].icono)
		
