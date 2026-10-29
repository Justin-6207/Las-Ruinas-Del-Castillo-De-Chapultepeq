extends Node3D

@export var ObjetoContenido: String 
@onready var SpriteObjeto = $"SpriteObjeto"
@onready var ContenedorSonidos = $"Sonidos"

var invObj = G.DataObjetos
var sonidos = {}

func usar():
	if ObjetoContenido == "Llave":
		ObjetoContenido = ""
		G.MiPersonaje.llavesRecolectadas += 1
		self.set_meta("Inusable",true)
		await get_tree().create_timer(2.0).timeout
		queue_free()

func _ready():
	for sonido in ContenedorSonidos.get_children():
		sonidos[sonido.name] = sonido
	G.MisInteraccionables.push_back(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_basis = G.basisCam(global_position)

	if ObjetoContenido != "":
		scale = invObj[ObjetoContenido].proporcion
		SpriteObjeto.texture  = load(invObj[ObjetoContenido].icono)
	else:
		SpriteObjeto.texture = null	
		
