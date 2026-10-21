extends Sprite3D

var valorInterpolacion = 0
var alJugador = true
var MiPersonaje
var posManoInicial
var posManoFinal

func ManejarMano(delta):
	var objetoMasCercano
	var distancia = 99999
	
	for interaccionable in G.MisInteraccionables:
		var dir = (G.MiPersonaje.global_position - interaccionable.global_position) * Vector3(1,0,1)
		var dp = dir.normalized().dot(G.Camara.global_basis.z)
		var angle = rad_to_deg(acos(dp))
		var distTemp = (G.MiPersonaje.global_position - interaccionable.global_position).length()

		if distTemp < distancia and distTemp <= 2.5 and angle <= 25:
			distancia = distTemp
			objetoMasCercano = interaccionable
		
	var Cambio = false
	if objetoMasCercano:
		if alJugador == true:
			Cambio = true
		alJugador = false
	else:
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

	valorInterpolacion += delta
	if (valorInterpolacion > 1):
		valorInterpolacion = 1
	
	global_position = posManoInicial.lerp(posManoFinal, valorInterpolacion)
	
	var DireccionHaciaJugador = (G.Camara.global_position-global_position).normalized()
	global_position += DireccionHaciaJugador * .15
	global_basis = basis.looking_at(DireccionHaciaJugador)
	scale = Vector3(.1,.1,.1)

func _ready():
	posManoInicial = global_position

func _process(delta):
	ManejarMano(delta)
