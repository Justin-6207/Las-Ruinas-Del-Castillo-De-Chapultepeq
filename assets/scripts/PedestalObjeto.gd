extends Node3D

@export var ObjetoContenido: String 
@onready var SpriteObjeto = $"SpriteObjeto"

var invObj = Globales.Objetos
var botones = []
var invPers

func usar():
	ObjetoContenido = ""

func _ready():
	invPers = Globales.MiPersonaje.miInventario
	Globales.MisInteraccionables.push_back(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var DireccionHaciaJugador = (Globales.Camara.global_position-global_position).normalized()
	global_basis = basis.looking_at(DireccionHaciaJugador)
	scale = Vector3(.1,.1,.1)
	
	if ObjetoContenido != "":
		SpriteObjeto.texture  = load(invObj[ObjetoContenido].icono)
		
