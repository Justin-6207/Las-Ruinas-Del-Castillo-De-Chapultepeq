extends Node3D

@export var pared: PackedScene
@export var puerta: PackedScene
@export var pedestalObjeto : PackedScene
@export var paredVacia: PackedScene
@export var piso: PackedScene
@export var enemigoBase: PackedScene
@export var dificultad = 0

@onready var Paredes = $"Paredes"
@onready var Piso = $"Piso"
@onready var Objetos = $"Objetos"
@onready var Enemigos = $"Enemigos"

var laberinto
#################################################################################

func obtenerNodosVecinosConSalidaYEsquinas(y : int,x : int):
	var nodosVecinos = []
	var tamLabArreglado = laberinto.size()-1
	
	if (y-2 > 0) and (y > 0) and (x-2 > 0) and (x > 0):
		nodosVecinos.push_back([laberinto[y - 1][x - 1],laberinto[y - 2][x - 2],[y - 1,x - 1],"NO"])
		
	if (y-2 > 0) and (y > 0) and (x+2 < tamLabArreglado) and (x < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y - 1][x + 1],laberinto[y - 2][x + 2],[y - 1,x + 1],"NE"])
	
	if (y+2 < tamLabArreglado) and (y < tamLabArreglado) and (x-2 > 0) and (x > 0):
		nodosVecinos.push_back([laberinto[y - 1][x - 1],laberinto[y - 2][x - 2],[y - 1,x - 1],"SO"])
		
	if (y+2 < tamLabArreglado) and (y < tamLabArreglado) and (x+2 < tamLabArreglado) and (x < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y - 1][x + 1],laberinto[y - 2][x + 2],[y - 1,x + 1],"SE"])
	
	
	#############################################################################################

	if (y-2 > 0) and (y > 0):
		nodosVecinos.push_back([laberinto[y - 1][x],laberinto[y - 2][x],[y-1,x],"N"])
	
	if (y+2 < tamLabArreglado) and (y < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y + 1][x],laberinto[y + 2][x],[y+1,x],"S"])
		
	if (x+2 < tamLabArreglado) and (x < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y][x + 1],laberinto[y][x + 2],[y,x+1],"E"])
	
	if (x-2 > 0) and (x > 0):
		nodosVecinos.push_back([laberinto[y][x - 1],laberinto[y][x - 2],[y,x-1],"O"])
	
	return nodosVecinos

func obtenerNodosVecinosConSalida(y : int,x : int):
	var nodosVecinos = []
	var tamLabArreglado = laberinto.size()-1
	
	if (y-2 > 0) and (y > 0):
		nodosVecinos.push_back([laberinto[y - 1][x],laberinto[y - 2][x],[y-1,x],"N"])
	
	if (y+2 < tamLabArreglado) and (y < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y + 1][x],laberinto[y + 2][x],[y+1,x],"S"])
		
	if (x+2 < tamLabArreglado) and (x < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y][x + 1],laberinto[y][x + 2],[y,x+1],"E"])
	
	if (x-2 > 0) and (x > 0):
		nodosVecinos.push_back([laberinto[y][x - 1],laberinto[y][x - 2],[y,x-1],"O"])
	
	return nodosVecinos

func obtenerNodosVecinos(y : int,x : int):
	var nodosVecinos = []
	var tamLabArreglado = laberinto.size()-1
	
	if (y-1 > 0) and (y > 0):
		nodosVecinos.push_back([laberinto[y - 1][x],[y-1,x],"N"])
	
	if (y+1 < tamLabArreglado) and (y < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y + 1][x],[y+1,x],"S"])
		
	if (x+1 < tamLabArreglado) and (x < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y][x + 1],[y,x+1],"E"])
	
	if (x-1 > 0) and (x > 0):
		nodosVecinos.push_back([laberinto[y][x - 1],[y,x-1],"O"])
	
	return nodosVecinos

func obtenerNodosVecinosYEsquinas(y : int,x : int):
	var nodosVecinos = []
	var tamLabArreglado = laberinto.size()-1
	
	if (y-1 > 0) and (y > 0) and (x-1 > 0) and (x > 0):
		nodosVecinos.push_back([laberinto[y - 1][x - 1],[y - 1,x - 1],"NO"])
		
	if (y-1 > 0) and (y > 0) and (x+1 < tamLabArreglado) and (x < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y - 1][x + 1],[y - 1,x + 1],"NE"])
	
	if (y+1 < tamLabArreglado) and (y < tamLabArreglado) and (x-1 > 0) and (x > 0):
		nodosVecinos.push_back([laberinto[y - 1][x - 1],[y - 1,x - 1],"SO"])
		
	if (y+1 < tamLabArreglado) and (y < tamLabArreglado) and (x+1 < tamLabArreglado) and (x < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y - 1][x + 1],[y - 1,x + 1],"SE"])
	
	
	#############################################################################################
	
	if (y-1 > 0) and (y > 0):
		nodosVecinos.push_back([laberinto[y - 1][x],[y-1,x],"N"])
	
	if (y+1 < tamLabArreglado) and (y < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y + 1][x],[y+1,x],"S"])
		
	if (x+1 < tamLabArreglado) and (x < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y][x + 1],[y,x+1],"E"])
	
	if (x-1 > 0) and (x > 0):
		nodosVecinos.push_back([laberinto[y][x - 1],[y,x-1],"O"])
	
	return nodosVecinos

#################################################################################

func generarCuartosArray(numCuartos : int):
	var cuartos = []
	var tamanoLaberinto = laberinto.size()
	var tamLabArreglado = tamanoLaberinto-1
	var RNG = RandomNumberGenerator.new()
	
	while numCuartos > 0:
		var y = RNG.randi_range(0,tamLabArreglado)
		var x = RNG.randi_range(0,tamLabArreglado)
		if (y == 0 and x == 0) or (y == -1) or (x == -1):
			continue
		if laberinto[y][x] == 0:
			var nodosVecinos = obtenerNodosVecinosYEsquinas(y,x)
			var nodosLlenos = 0
			var iter = 0
			
			for vecino in nodosVecinos:
				if vecino[0] == 1:
					nodosLlenos += 1
				elif vecino[0] == 2:
					nodosLlenos = 0
					break
					
				iter += 1
				
			if nodosLlenos >= 1:
				var cuarto = []
				cuarto.push_back([y,x])
				numCuartos -= 1
				laberinto[y][x] = 2
				
				for nodoVecino in nodosVecinos:
					cuarto.push_back([nodoVecino[1][0],nodoVecino[1][1]])
					laberinto[nodoVecino[1][0]][nodoVecino[1][1]] = 2
					
				cuartos.push_back(cuarto)
			else:
				continue
				
	return cuartos

func eliminarCallejonesSinSalida():
	var tamanoLaberinto = laberinto.size()
	var tamLabArreglado = tamanoLaberinto-1
	
	for y in range(0,tamanoLaberinto):
		for x in range(0,tamanoLaberinto):
			if laberinto[y][x] == 0:
				var nodosVecinos = obtenerNodosVecinosConSalida(y,x)
				var nodosLlenos = 0
				var nodoCC
				
				var iter = 0
				for vecino in nodosVecinos:
					if vecino[0] == 1:
						nodosLlenos += 1
						if vecino[1] == 0:
							nodoCC = iter
					iter += 1
					
				if nodosLlenos >= nodosVecinos.size()-1 and nodosVecinos.size() >= 3 and nodoCC:
					laberinto[ nodosVecinos[nodoCC][2][0] ] [ nodosVecinos[nodoCC][2][1] ] = 0
				else:
					continue

func generarLaberintoArray(tamanoLaberinto : int):
	var laberintoVisitado = []
	var nodosAVisitar = [[Vector2(1,1),Vector2(0,0)]]
	var miPosicion = Vector2(1,1)
	var tamLabArreglado = tamanoLaberinto-1
	
	for x in range(0,tamanoLaberinto):
		laberinto.push_back([])
		laberintoVisitado.push_back([])
		for y in range(0,tamanoLaberinto):
			
			var Condicion1 = ((y+1)%2 == 0) and ((x+1)%2 == 0)
			var Condicion2 = y < tamLabArreglado and x < tamLabArreglado
			var Condicion3 = y > 0 and x > 0
			
			if Condicion1 and Condicion2 and Condicion3:
				laberinto[x].push_back(0)
			else:
				laberinto[x].push_back(1)
			laberintoVisitado[x].push_back(0)
	
	while  true:
		if nodosAVisitar.size() <= 0:
			break
		
		var nodosPares = nodosAVisitar.pop_front()
		var vecino = nodosPares[0]
		var anterior = nodosPares[1]
		var direccion = (vecino - anterior).normalized()

		miPosicion = vecino
		if laberintoVisitado[miPosicion.x][miPosicion.y] == 1:
			continue

		laberinto[anterior.x + direccion.x][anterior.y + direccion.y] = 0
		laberintoVisitado[miPosicion.x][miPosicion.y] = 1
		
		var nodosVecinos = [
			Vector2(miPosicion.x + 2, miPosicion.y),
			Vector2(miPosicion.x - 2, miPosicion.y),
			Vector2(miPosicion.x, miPosicion.y - 2),
			Vector2(miPosicion.x, miPosicion.y + 2),
		]
		nodosVecinos.shuffle()

		for nodo in range(0,3):
			var nodoVecino = nodosVecinos.pop_back()
			var condicion1 = (nodoVecino.x <= 0 or nodoVecino.x >= tamLabArreglado)
			var condicion2 = (nodoVecino.y <= 0 or nodoVecino.y >= tamLabArreglado)
			
			if (condicion1 or condicion2):
				continue
				
			var condicion3 = laberintoVisitado[nodoVecino.x][nodoVecino.y] == 1
			
			if condicion3:
				continue
			else:
				nodosAVisitar.push_back([nodoVecino,miPosicion])

	laberinto[0][0] = 1
	
	eliminarCallejonesSinSalida()

#################################################################################

func darPosMeta(Piso,Posicion):
	Piso.find_child("MeshInstance3D").find_child("StaticBody3D").set_meta("PosicionArray", [Posicion[0],Posicion[1]])

func crearLaberintoFisico():
	var x = 0
	var z = 0
	var startPos = Vector3(-1,0,-1)

	var PosicionInicial 
	var tamLabArreglado = laberinto.size()-1
	var paredesLaberinto = []
	var pisosLaberinto = []
	
	for c in range(0,laberinto.size()):
		paredesLaberinto.push_back([])
		pisosLaberinto.push_back([])
	
	for contenedor in laberinto:
		for nodo in contenedor:
			var movingPos = startPos + Vector3(x,0,z)
			var nodosVecinos = obtenerNodosVecinos(z,x)
			var paredGenerada
			
			if nodo == 1:
				paredGenerada = pared.instantiate()
				paredGenerada.position = movingPos
				Paredes.add_child(paredGenerada)
				
			elif nodo == 2:
				paredGenerada = paredVacia.instantiate()
				paredGenerada.position = movingPos
				Paredes.add_child(paredGenerada)
				
			var miPiso = piso.instantiate()
			miPiso.position = movingPos + Vector3(0,-.5,0)
			miPiso.name = str(z) + "-" + str(x)
			pisosLaberinto[z].push_back(miPiso)
			darPosMeta(miPiso,[z,x])
			Piso.add_child(miPiso)
			
			if paredGenerada:
				paredGenerada.name = str(z) + "-" + str(x)
				paredesLaberinto[z].push_back(paredGenerada)
			else:
				paredesLaberinto[z].push_back(null)
				
			x += 1
		z += 1
		x = 0

	return [paredesLaberinto, pisosLaberinto]

func crearCuartosFisicos(cuartosArray : Array,paredesLaberinto : Array):
	var cuartosFisicos = []
	
	for cuarto in cuartosArray:
		var encontroSalida = false
		var posPuertaAnterior
		
		var CuartoFisico = {
			"Piso" : [],
			"PisoPrincipal" : null,
		}
		
		for pos in cuarto:
			var nodosVecinosRestringidos = obtenerNodosVecinosConSalida(pos[0],pos[1])
			var nodosVecinos = obtenerNodosVecinos(pos[0],pos[1])
			var paredCorrespondiente = paredesLaberinto[pos[0]][pos[1]]

			
			CuartoFisico.Piso.push_back(paredCorrespondiente)
			
			for nodoVecino in nodosVecinosRestringidos:
				if encontroSalida == true:
					break
				
				if nodoVecino[0] == 0:
					var POSSalvada
					var BASISSalvada
					
					if not CuartoFisico.PisoPrincipal:
						CuartoFisico.PisoPrincipal = paredCorrespondiente
					
					if posPuertaAnterior != null:
						if (paredCorrespondiente.global_position - posPuertaAnterior).length() <= 4:
							continue
					
					if nodoVecino[3] == "N":
						POSSalvada = paredCorrespondiente.find_child("Frente").global_position
						BASISSalvada = paredCorrespondiente.find_child("Frente").basis
						paredCorrespondiente.find_child("Frente").queue_free()
					elif nodoVecino[3] == "S":
						POSSalvada = paredCorrespondiente.find_child("Detras").global_position
						BASISSalvada = paredCorrespondiente.find_child("Detras").basis
						paredCorrespondiente.find_child("Detras").queue_free()
					elif nodoVecino[3] == "E":
						POSSalvada = paredCorrespondiente.find_child("Derecha").global_position
						BASISSalvada = paredCorrespondiente.find_child("Derecha").basis
						paredCorrespondiente.find_child("Derecha").queue_free()
					elif nodoVecino[3] == "O":	
						POSSalvada = paredCorrespondiente.find_child("Izquierda").global_position
						BASISSalvada = paredCorrespondiente.find_child("Izquierda").basis
						paredCorrespondiente.find_child("Izquierda").queue_free()
					
					laberinto[pos[0]][pos[1]] = 3
					
					var PuertaFisica = puerta.instantiate()
					Objetos.add_child(PuertaFisica)
					PuertaFisica.set_meta("Puerta",true)
					
					posPuertaAnterior = paredCorrespondiente.global_position
					PuertaFisica.global_position = POSSalvada
					PuertaFisica.basis = BASISSalvada
					PuertaFisica.position += Vector3.UP * .25
					
					
			
			for nodoVecino in nodosVecinos:
				if not (laberinto[nodoVecino[1][0]][nodoVecino[1][1]] >= 2):
					continue
				if nodoVecino[2] == "N":
					paredCorrespondiente.find_child("Frente").queue_free()
				elif nodoVecino[2] == "S":
					paredCorrespondiente.find_child("Detras").queue_free()
				elif nodoVecino[2] == "E":
					paredCorrespondiente.find_child("Derecha").queue_free()
				elif nodoVecino[2] == "O":	
					paredCorrespondiente.find_child("Izquierda").queue_free()
				elif nodoVecino[2] == "NE":
					paredCorrespondiente.find_child("Derecha").queue_free()
					paredCorrespondiente.find_child("Frente").queue_free()
				elif nodoVecino[2] == "NO":
					paredCorrespondiente.find_child("Izquierda").queue_free()
					paredCorrespondiente.find_child("Frente").queue_free()
				elif nodoVecino[2] == "SE":
					paredCorrespondiente.find_child("Derecha").queue_free()
					paredCorrespondiente.find_child("Detras").queue_free()
				elif nodoVecino[2] == "SO":
					paredCorrespondiente.find_child("Izquierda").queue_free()
					paredCorrespondiente.find_child("Detras").queue_free()
					
		cuartosFisicos.push_back(CuartoFisico)
	
	return cuartosFisicos

func crearObjetosEnCuartos(cuartosFisicos : Array):
	for cuarto in cuartosFisicos:
		var pisoPrincipal = cuarto.PisoPrincipal
		var pisoElegido
		var distancia = 9999
		
		for piso in cuarto.Piso:
			var tempDist = (piso.global_position - pisoPrincipal.global_position).length()
			if tempDist < distancia:
				pisoElegido = piso
		
		var MiLlave = pedestalObjeto.instantiate()
		MiLlave.ObjetoContenido = "Llave"
		Objetos.add_child(MiLlave)
		
		MiLlave.global_position = pisoElegido.global_position + Vector3.UP

func generarEnemigo(paredesLaberinto : Array,NombreEnemigo):
	var posicionMasLejana
	var distancia = 99999999
	var enemigo = enemigoBase.instantiate()
	enemigo.tipoEnemigo = "Vicente_Suarez"
	
	for fila in paredesLaberinto:
		for piso in fila:
			var distanciaTemp = (Vector3.ZERO - piso.global_position * Vector3(1,0,1))

			if piso.get_meta("Libre") and distanciaTemp.length() < distancia:
				distancia = distanciaTemp.length()
				posicionMasLejana = piso.global_position
	
	Enemigos.add_child(enemigo)
	enemigo.global_position = Vector3.ZERO  + Vector3.UP
	
#################################################################################

func _ready():
	G.PathfindObject = null
	G.MisInteraccionables = []
	laberinto = []
	await get_tree().create_timer(.05).timeout
	
	var tamanoLaberinto
	var cuartosAGenerar
	var llavesAGenerar
	var generarEnemigos = false
	
	if dificultad == 0:
		generarEnemigos = false
		cuartosAGenerar = 5
		llavesAGenerar = 3
		tamanoLaberinto = 25
	elif dificultad == 1:
		generarEnemigos = true
		cuartosAGenerar = 7
		llavesAGenerar = 5
		tamanoLaberinto = 25	
	
	generarLaberintoArray(tamanoLaberinto)
	var cuartosArray = generarCuartosArray(cuartosAGenerar)
	var retornoFisico = crearLaberintoFisico()
	var paredesFisicas = retornoFisico[0]
	var pisosFisicos = retornoFisico[1]
	var cuartosFisicos = crearCuartosFisicos(cuartosArray,paredesFisicas)
	crearObjetosEnCuartos(cuartosFisicos)
	
	if generarEnemigos: 
		generarEnemigo(pisosFisicos,"Vicente_Suarez")
	
	G.PathfindObject = PathfindingClass.new(laberinto,pisosFisicos)
