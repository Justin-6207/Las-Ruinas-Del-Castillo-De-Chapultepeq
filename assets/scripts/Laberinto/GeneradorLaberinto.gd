extends Node3D

@export var pared: PackedScene
@export var puerta: PackedScene
@export var pedestalObjeto : PackedScene
@export var paredVacia: PackedScene
@export var piso: PackedScene
@export var pisoCuarto: PackedScene
@export var enemigoBase: PackedScene
@export var dificultad = 0

@onready var Paredes = $"Paredes"
@onready var Pisos = $"Piso"
@onready var Objetos = $"Objetos"
@onready var Enemigos = $"Enemigos"
@onready var ContenedorSonidos = $ContenedorSonidos

var laberinto = []
var sonidos = {}
#################################################################################

func obtenerNodosVecinosConSalida(y : int,x : int):
	var nodosVecinos = []
	var tamLabArreglado = laberinto.size()-1
	
	if (y-2 >= 0) and (y >= 0):
		nodosVecinos.push_back([laberinto[y - 1][x],laberinto[y - 2][x],[y-1,x],"N"])
	
	if (y+2 <= tamLabArreglado) and (y <= tamLabArreglado):
		nodosVecinos.push_back([laberinto[y + 1][x],laberinto[y + 2][x],[y+1,x],"S"])
		
	if (x+2 <= tamLabArreglado) and (x <= tamLabArreglado):
		nodosVecinos.push_back([laberinto[y][x + 1],laberinto[y][x + 2],[y,x+1],"E"])
	
	if (x-2 >= 0) and (x >= 0):
		nodosVecinos.push_back([laberinto[y][x - 1],laberinto[y][x - 2],[y,x-1],"O"])
	
	return nodosVecinos

func obtenerNodosVecinos(y : int,x : int):
	var nodosVecinos = []
	var tamLabArreglado = laberinto.size()-1
	
	if (y-1 >= 0) and (y >= 0):
		nodosVecinos.push_back([laberinto[y - 1][x],[y-1,x],"N"])
	
	if (y+1 <= tamLabArreglado) and (y <= tamLabArreglado):
		nodosVecinos.push_back([laberinto[y + 1][x],[y+1,x],"S"])
		
	if (x+1 <= tamLabArreglado) and (x <= tamLabArreglado):
		nodosVecinos.push_back([laberinto[y][x + 1],[y,x+1],"E"])
	
	if (x-1 >= 0) and (x >= 0):
		nodosVecinos.push_back([laberinto[y][x - 1],[y,x-1],"O"])
	
	return nodosVecinos

func obtenerNodosVecinosYEsquinas(y : int,x : int):
	var nodosVecinos = []
	var tamLabArreglado = laberinto.size()-1
	
	if (y-1 >= 0) and (y >= 0) and (x-1 >= 0) and (x >= 0):
		nodosVecinos.push_back([laberinto[y - 1][x - 1],[y - 1,x - 1],"NO"])
		
	if (y-1 >= 0) and (y >= 0) and (x+1 <= tamLabArreglado) and (x <= tamLabArreglado):
		nodosVecinos.push_back([laberinto[y - 1][x + 1],[y - 1,x + 1],"NE"])
	
	if (y+1 <= tamLabArreglado) and (y <= tamLabArreglado) and (x-1 >= 0) and (x >= 0):
		nodosVecinos.push_back([laberinto[y - 1][x - 1],[y - 1,x - 1],"SO"])
		
	if (y+1 <= tamLabArreglado) and (y <= tamLabArreglado) and (x+1 <= tamLabArreglado) and (x <= tamLabArreglado):
		nodosVecinos.push_back([laberinto[y - 1][x + 1],[y - 1,x + 1],"SE"])
	
	
	#############################################################################################
	
	if (y-1 >= 0) and (y >= 0):
		nodosVecinos.push_back([laberinto[y - 1][x],[y-1,x],"N"])
	
	if (y+1 <= tamLabArreglado) and (y <= tamLabArreglado):
		nodosVecinos.push_back([laberinto[y + 1][x],[y+1,x],"S"])
		
	if (x+1 <= tamLabArreglado) and (x <= tamLabArreglado):
		nodosVecinos.push_back([laberinto[y][x + 1],[y,x+1],"E"])
	
	if (x-1 >= 0) and (x >= 0):
		nodosVecinos.push_back([laberinto[y][x - 1],[y,x-1],"O"])
	
	return nodosVecinos

func obtenerNodosVecinosLlenos(y : int,x : int):
	var nodosVecinos = obtenerNodosVecinos(y,x)
	var nodosRetorno = []
	for nodo in nodosVecinos:
		if nodo[0] == 1:
			nodosRetorno.append(nodo)
					
	return nodosRetorno

func ordernarNodosPorDistancia(Nodos : Array) -> Array:
	var nodosTemp = Nodos.duplicate()
	var nodosNuevos = []
	
	while nodosTemp.size() > 0:
		var CurrDist = 9999
		var itEl = 0
		
		var it = 0
		for pos in nodosTemp:
			var tempDist = (Vector2.ZERO - Vector2(pos[1],pos[0])).length()
			if tempDist < CurrDist:
				CurrDist = tempDist
				itEl = it
			it += 1
			
		nodosNuevos.push_back(nodosTemp[itEl])
		nodosTemp.remove_at(itEl)
	
	return nodosNuevos
	
#################################################################################

func generarCuartosArray(numCuartos : int):
	var cuartos = []
	var tamanoLaberinto = laberinto.size()
	var tamLabArreglado = tamanoLaberinto-1
	var RNG = RandomNumberGenerator.new()
	
	while numCuartos > 0:
		var y = RNG.randi_range(0,tamLabArreglado)
		var x = RNG.randi_range(0,tamLabArreglado)
		
		if (y == 0 and x == 0) or (y == -1) or (x == -1) :
			continue
		
		var haySalida = false
		var nodosVecinos = obtenerNodosVecinos(y,x)
		for nodo in nodosVecinos:
			if nodo[0] == 0:
				haySalida = true
		
		if laberinto[y][x] == 1 and haySalida:
			var nodosTotalesLlenos = []
			var nvll = obtenerNodosVecinosLlenos(y,x)
			nodosTotalesLlenos.append_array(nvll)
			
			for nodoVecino in nvll:
				var nvll2 = obtenerNodosVecinosLlenos(nodoVecino[1][0],nodoVecino[1][1])
				nodosTotalesLlenos.append_array(nvll2)
				
			if nvll.size() >= 2:
				var cuarto = [[y,x]]
				numCuartos -= 1
				laberinto[y][x] = 2
				
				for nodoVecino in nodosTotalesLlenos:
					cuarto.push_back([nodoVecino[1][0],nodoVecino[1][1]])
					laberinto[nodoVecino[1][0]][nodoVecino[1][1]] = 2
					
				cuartos.push_back(cuarto)
			else:
				continue
				
	return cuartos

func eliminarCallejonesSinSalida():
	var tamanoLaberinto = laberinto.size()
	for y in range(0,tamanoLaberinto):
		for x in range(0,tamanoLaberinto):
			if laberinto[y][x] == 0:
				var nodosVecinosSalida = obtenerNodosVecinosConSalida(y,x)
				var nodosVecinos = obtenerNodosVecinos(y,x)
				var nodosLlenos = 0
	
				var iter = 0
				for vecino in nodosVecinos:
					if vecino[0] == 1:
						nodosLlenos += 1
					iter += 1
				
				var nodosALimpiar = 2
				
				if nodosLlenos >= 4:
					nodosALimpiar = 3
					
				if nodosLlenos >= 3:
					for nodo in nodosVecinosSalida:
						if nodo[0] == 1:
							laberinto[nodo[2][0]][nodo[2][1]] = 0
							nodosALimpiar -= 1
							if nodosALimpiar <= 0:
								break
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

#################################################################################

func darPosMeta(Piso,Posicion):
	Piso.set_meta("PosicionArray", [Posicion[0],Posicion[1]])

func crearLaberintoFisico():
	var x = 0
	var y = 0
	var startPos = Vector3(0,0,0)
	var paredesLaberinto = []
	var pisosLaberinto = []
	
	for c in range(0,laberinto.size()):
		paredesLaberinto.push_back([])
		pisosLaberinto.push_back([])
	
	for contenedor in laberinto:
		for nodo in contenedor:
			var movingPos = startPos + Vector3(x,0,y)
			var paredGenerada
			
			if nodo == 1:
				paredGenerada = pared.instantiate()
				paredGenerada.position = movingPos
				Paredes.add_child(paredGenerada)
				
			elif nodo == 2:
				paredGenerada = paredVacia.instantiate()
				paredGenerada.position = movingPos
				Paredes.add_child(paredGenerada)
			
			var miPiso
			if nodo == 2:
				miPiso = pisoCuarto.instantiate()
				miPiso.position = movingPos + Vector3(0,-.5,0)
				miPiso.name = str(y) + "-" + str(x)
			else:
				miPiso = piso.instantiate()
				miPiso.position = movingPos + Vector3(0,-.5,0)
				miPiso.name = str(y) + "-" + str(x)
			
			if nodo == 0:
				G.EspaciosVaciosLaberintoArray.append([y,x])
			
			pisosLaberinto[y].push_back(miPiso)
			darPosMeta(miPiso,[y,x])
			
			if nodo == 0:
				miPiso.set_meta("Libre",true)
			else:
				miPiso.set_meta("Libre",null)
			
			
			Pisos.add_child(miPiso)
			
			if paredGenerada:
				paredGenerada.name = str(y) + "-" + str(x)
				paredesLaberinto[y].push_back(paredGenerada)
			else:
				paredesLaberinto[y].push_back(null)
				
			if x == laberinto.size()-1 and y == laberinto.size()-1:
				G.FinalLaberinto = miPiso
			
			if x == 1 and y == 1:
				G.InicioLaberintoJugador = miPiso
				
			if x == 1 and y == 1:
				G.MiPersonaje.global_position = miPiso.global_position + Vector3.UP * .5
				
			x += 1
		y += 1
		x = 0

	return [paredesLaberinto, pisosLaberinto]

func crearPuertaAPartirDeNodos(ListaNodos : Array, paredesLaberinto):
	for pos in ListaNodos:
		var NodosVecinos = obtenerNodosVecinos(pos[0],pos[1])
		for nodoVecino in NodosVecinos:
			if nodoVecino[0] == 0:
				var Objeto = paredesLaberinto[pos[0]][pos[1]]
				var POSSalvada
				var BASISSalvada
				
				var inicio = G.PathfindObject.genKey(1,1)
				var fin = G.PathfindObject.genKey(nodoVecino[1][0],nodoVecino[1][1])
				var camino
				
				camino = G.PathfindObject.encontrarCamino(inicio,fin)
				
				if not camino:
					continue
				
				if nodoVecino[2] == "N":
					POSSalvada = Objeto.find_child("Frente").global_position
					BASISSalvada = Objeto.find_child("Frente").basis
					Objeto.find_child("Frente").queue_free()
				elif nodoVecino[2] == "S":
					POSSalvada = Objeto.find_child("Detras").global_position
					BASISSalvada = Objeto.find_child("Detras").basis
					Objeto.find_child("Detras").queue_free()
				elif nodoVecino[2] == "E":
					POSSalvada = Objeto.find_child("Derecha").global_position
					BASISSalvada = Objeto.find_child("Derecha").basis
					Objeto.find_child("Derecha").queue_free()
				elif nodoVecino[2] == "O":	
					POSSalvada = Objeto.find_child("Izquierda").global_position
					BASISSalvada = Objeto.find_child("Izquierda").basis
					Objeto.find_child("Izquierda").queue_free()
				
				var PuertaFisica = puerta.instantiate()
				Objetos.add_child(PuertaFisica)
				PuertaFisica.set_meta("Puerta",true)
				PuertaFisica.global_position = POSSalvada
				PuertaFisica.basis = BASISSalvada.scaled(PuertaFisica.basis.get_scale())
				PuertaFisica.position += Vector3.UP * .5
				
				laberinto[nodoVecino[1][0]][nodoVecino[1][1]] = 4
				laberinto[pos[0]][pos[1]] = 3
				
				return [PuertaFisica,Objeto]
	print("no regrese nada ):")
	
func crearCuartosFisicos(cuartosArray : Array,paredesLaberinto : Array):
	var cuartosFisicos = []
	for cuarto in cuartosArray:
		var CuartoFisico = {
			"Piso" : [],
			"PisoPrincipal" : null,
		}
		
		var nodosOrdenados = ordernarNodosPorDistancia(cuarto)
		var retorno = crearPuertaAPartirDeNodos(nodosOrdenados, paredesLaberinto)
		nodosOrdenados.reverse()
		crearPuertaAPartirDeNodos(nodosOrdenados, paredesLaberinto)
		
		if retorno == null:
			print(cuarto)
			for y in laberinto:
				print(y)
		
		CuartoFisico.PisoPrincipal = retorno[1]

		for pos in cuarto:
			var nodosVecinos = obtenerNodosVecinos(pos[0],pos[1])
			var paredCorrespondiente = paredesLaberinto[pos[0]][pos[1]]
			CuartoFisico.Piso.push_back(paredCorrespondiente)

			for nodoVecino in nodosVecinos:
				var valor = laberinto[nodoVecino[1][0]][nodoVecino[1][1]]
				if not (valor == 2 or valor == 3):
					continue
				if nodoVecino[2] == "N":
					paredCorrespondiente.find_child("Frente").queue_free()
				elif nodoVecino[2] == "S":
					paredCorrespondiente.find_child("Detras").queue_free()
				elif nodoVecino[2] == "E":
					paredCorrespondiente.find_child("Derecha").queue_free()
				elif nodoVecino[2] == "O":	
					paredCorrespondiente.find_child("Izquierda").queue_free()
		cuartosFisicos.push_back(CuartoFisico)
		
	return cuartosFisicos

func crearObjetosEnCuartos(cuartosFisicos : Array,llavesAGenerar):
	for cuarto in cuartosFisicos:
		var pisoPrincipal = cuarto.PisoPrincipal
		var pisoElegido
		var distancia = 9999

		for piso in cuarto.Piso:
			var tempDist = (piso.global_position - pisoPrincipal.global_position).length()
			if tempDist < distancia:
				distancia = tempDist
				pisoElegido = piso
		
		var MiLlave = pedestalObjeto.instantiate()
		
		if llavesAGenerar > 0:
			llavesAGenerar -= 1
			MiLlave.ObjetoContenido = "Llave"
		else:
			MiLlave.ObjetoContenido = GameData.ObjetosGenerables.pick_random()	

		Objetos.add_child(MiLlave)
		MiLlave.global_position = pisoElegido.global_position + Vector3.UP
		
		G.setPosArray(MiLlave)

func generarEnemigo(NombreEnemigo):
	var enemigo = enemigoBase.instantiate()
	enemigo.tipoEnemigo = NombreEnemigo
	Enemigos.add_child(enemigo)
	enemigo.global_position = (G.InicioLaberintoJugador.global_position * Vector3(1,0,1)) + Vector3.UP

func generarSalidaFisica(pisosFisicos : Array):
	var dist = 0
	var pisoS
	
	while pisoS == null:
		for piso in Pisos.get_children():
			var distTemp = piso.global_position - G.MiPersonaje.global_position
			distTemp = distTemp.length()
			if (distTemp > dist) and piso.get_meta("Libre"):
				dist = distTemp
				pisoS = piso
	
	var MiSalida = pedestalObjeto.instantiate()
	MiSalida.ObjetoContenido = "Salida"
	MiSalida.name = "SALIDA"
	
	Objetos.add_child(MiSalida)
	MiSalida.global_position = pisoS.global_position + Vector3.UP * 2

#################################################################################

func tutorialIntro():
	G.Anunciante.Anuncio = "Bienvenido al tutorial del juego"
	await get_tree().create_timer(3.5).timeout
	G.Anunciante.Anuncio = "A continuacion se mostraran los controles basicos del juego"
	await get_tree().create_timer(3.5).timeout
	G.Anunciante.Anuncio = "Controles - Boton del Mouse Izquierdo: Abrir / cerrar puertas, agarrar objetos"
	await get_tree().create_timer(3.5).timeout
	G.Anunciante.Anuncio = "Controles - Boton del Mouse Derecho: Usar objetos en el inventario"
	await get_tree().create_timer(3.5).timeout
	G.Anunciante.Anuncio = "Controles - CTRL Izquierdo: correr"
	await get_tree().create_timer(3.5).timeout
	G.Anunciante.Anuncio = "Controles - Teclas 1, 2 y 3: Cambiar de objeto dentro del inventario"
	await get_tree().create_timer(3.5).timeout
	G.Tutorial = true

func _ready():
	while G.MiPersonaje == null:
		await get_tree().process_frame
		
	for sonido in ContenedorSonidos.get_children():
		sonidos[sonido.name] = sonido
		
	G.MisInteraccionables = Objetos
	G.MisEnemigos = Enemigos
	G.EspaciosVaciosLaberintoArray = []
	G.MiPersonaje.MiInventario[0] = GameData.ObjetosGenerables.pick_random()
	G.ObjetosLaberinto = Objetos
	
	var tamanoLaberinto
	var cuartosAGenerar
	var llavesAGenerar
	var generarEnemigos = false
	
	if dificultad == 0:
		sonidos["Tutorial"].play()
		WorkerThreadPool.add_task(tutorialIntro)
		cuartosAGenerar = 5
		llavesAGenerar = 3
		tamanoLaberinto = 20
		
	elif dificultad == 1:
		sonidos["Nivel1"].play()
		cuartosAGenerar = 7
		llavesAGenerar = 5
		tamanoLaberinto = 20
		
	elif dificultad == 2:
		sonidos["Nivel2"].play()
		cuartosAGenerar = 10
		llavesAGenerar = 7
		tamanoLaberinto = 40
		
	elif dificultad >= 3:
		sonidos["Nivel2"].play()
		cuartosAGenerar = 13
		llavesAGenerar = 9
		tamanoLaberinto = 60
		
	elif dificultad >= 4:
		sonidos["Nivel2"].play()
		cuartosAGenerar = 16
		llavesAGenerar = 12
		tamanoLaberinto = 80
	
	generarLaberintoArray(tamanoLaberinto)
	eliminarCallejonesSinSalida() 
	var cuartosArray = generarCuartosArray(cuartosAGenerar)
	
	var retornoFisico = crearLaberintoFisico()
	var paredesFisicas = retornoFisico[0]
	var pisosFisicos = retornoFisico[1]
	
	G.PathfindObject = PathfindingClass.new(laberinto,pisosFisicos)
	
	var cuartosFisicos = crearCuartosFisicos(cuartosArray,paredesFisicas)
	crearObjetosEnCuartos(cuartosFisicos,llavesAGenerar)
	generarSalidaFisica(pisosFisicos)
	
	G.LlavesTotales = llavesAGenerar
	G.PathfindObject = PathfindingClass.new(laberinto,pisosFisicos)
	
	G.LaberintoArray = laberinto.duplicate(true)
	G.LaberintoFisico = pisosFisicos
	
	if dificultad == 1:
		G.Anunciante.Anuncio = "Enemigos presentes: Nicolas Bravo"
		await get_tree().create_timer(2).timeout
	elif dificultad >= 2:
		G.Anunciante.Anuncio = "Enemigos presentes: Nicolas Bravo, Francisco Marquez"
		await get_tree().create_timer(2).timeout
		
	if dificultad >= 1:
		G.Anunciante.Anuncio = "Tendras 10 segundos de ventaja"
		await get_tree().create_timer(10).timeout
		generarEnemigo("Nicolas_Bravo")
		if dificultad >= 2:
			generarEnemigo("Francisco_Marquez")
