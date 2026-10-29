extends Sprite3D
@export var ObjetoContenido = ""
var invObj = G.DataObjetos

var sonidos = {}
func _ready():
	for sonido in get_children():
		sonidos[sonido.name] = sonido

func  UsarObjeto(NombreObjeto):
	if NombreObjeto == "Espada":
		sonidos["Espada"].play()

func _process(delta):
	global_basis = G.basisCam(global_position)

	if ObjetoContenido != "":
		scale = Vector3(.1,.1,.1)
		texture = load(invObj[ObjetoContenido].icono)
	else:
		texture = null	
		
