extends Sprite3D
@export var ObjetoContenido = ""
var invObj = G.ObjetosData

var sonidos = {}
func _ready():
	for sonido in get_children():
		sonidos[sonido.name] = sonido

func  UsarObjeto(NombreObjeto):
	if NombreObjeto == "Espada":
		sonidos["Espada"].play()
		var gaa = false
		for enemigo in G.MisEnemigos.get_children():
			var distancia = (enemigo.global_position - global_position).length()
			if distancia <= 2:
				gaa = true
				enemigo.stunned = 4
		if gaa:
			sonidos["EspadaCritica"].play()

func _process(delta):
	global_basis = G.basisCam(global_position)
	if ObjetoContenido != "":
		scale = Vector3(.1,.1,.1)
		texture = load(invObj[ObjetoContenido].icono)
	else:
		texture = null	
		
