extends Sprite3D

var valorInterpolacion = 0
var alJugador = true
var posManoInicial
var posManoFinal
var interaccionableCercano

func interactuarConObjeto():
	if interaccionableCercano:
		interaccionableCercano.usar()

func ManejarMano(delta):
	var objetoMasCercano
	var distancia = 99999
	var indice = -1
	
	for interaccionable in G.MisInteraccionables.get_children():
		indice += 1
		if interaccionable == null or interaccionable.get_meta("Inusable"):
			break
			
		var dir =  G.dirCam(interaccionable.global_position)
		var dp = dir.dot(G.Camara.global_basis.z)
		var angle = rad_to_deg(acos(dp))
		var distTemp = (G.MiPersonaje.global_position - interaccionable.global_position).length()

		if distTemp < distancia and distTemp <= 3 and angle <= 40:
			distancia = distTemp
			objetoMasCercano = interaccionable
		
	var Cambio = false
	if objetoMasCercano:
		interaccionableCercano = objetoMasCercano
		if alJugador == true:
			Cambio = true
		alJugador = false
	else:
		interaccionableCercano = null
		if alJugador == false:
			Cambio = true
		alJugador = true
		
	if Cambio == true:
		valorInterpolacion = 0
	else:
		if alJugador == true:
			posManoInicial = global_position
			posManoFinal = G.MiPersonaje.global_position - Vector3(0,2,0)
		else:
			posManoInicial = global_position
			posManoFinal = objetoMasCercano.global_position	

	valorInterpolacion += delta * 2
	if (valorInterpolacion > 1):
		valorInterpolacion = 1
	
	global_position = posManoInicial.lerp(posManoFinal, valorInterpolacion)
	
	var DireccionHaciaJugador = G.dirCam(global_position)
	global_position += DireccionHaciaJugador * .15
	global_basis = G.basisCam(global_position)
	scale = Vector3(.1,.1,.1)

func _ready():
	posManoInicial = global_position

func _process(delta):
	ManejarMano(delta)
