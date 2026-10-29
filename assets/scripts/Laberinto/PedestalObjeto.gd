extends Node3D

@export var ObjetoContenido: String 
@onready var SpriteObjeto = $"SpriteObjeto"
@onready var ContenedorSonidos = $"Sonidos"

var invObj = G.ObjetosData
var sonidos = {}

func usar():
	if ObjetoContenido == "Llave":
		ObjetoContenido = ""
		G.MiPersonaje.llavesRecolectadas += 1
		self.set_meta("Inusable",true)
		sonidos["Llaves"].play()
		if (G.MiPersonaje.llavesRecolectadas >= G.LlavesTotales):
			G.Anunciante.Anuncio = "Encuentra la salida"
		
		await get_tree().create_timer(2.0).timeout
		queue_free()
	elif  ObjetoContenido == "Salida":
		if (G.MiPersonaje.llavesRecolectadas >= G.LlavesTotales):
			ObjetoContenido = ""
			queue_free()
			get_tree().change_scene_to_file("res://escenas/Inicio.tscn")
		else:
			sonidos["PuertaBloqueada"].play()
			G.Anunciante.Anuncio = "No tienes suficientes llaves para escapar"	
	else:
		var indice = 0
		for str in G.MiPersonaje.MiInventario:
			if str == "":
				G.MiPersonaje.MiInventario[indice] = ObjetoContenido
				ObjetoContenido = ""
				queue_free()
				return
			indice += 1
		
		var buffr = ObjetoContenido
		var ind = G.MiPersonaje.espacioEnLaMano
		var buffr2 = G.MiPersonaje.MiInventario[ind]
		
		G.MiPersonaje.MiInventario[ind] = buffr
		ObjetoContenido = buffr2
		
func _ready():
	for sonido in ContenedorSonidos.get_children():
		sonidos[sonido.name] = sonido

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.set_meta("NombreObjeto",ObjetoContenido)
	global_basis = G.basisCam(global_position)
	
	if ObjetoContenido != "":
		scale = invObj[ObjetoContenido].proporcion
		SpriteObjeto.texture  = load(invObj[ObjetoContenido].icono)
	else:
		SpriteObjeto.texture = null	
		
