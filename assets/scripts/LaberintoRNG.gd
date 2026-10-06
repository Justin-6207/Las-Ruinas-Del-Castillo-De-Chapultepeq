extends Node3D

@export var pared: PackedScene
@export var paredVacia: PackedScene
@export var piso: PackedScene

@onready var Paredes = $"Paredes"
@onready var Piso = $"Piso"
@onready var Objetos = $"Objetos"
# Called when the node enters the scene tree for the first time.

func obtenerNodosVecinosConSalida(laberinto,tamLabArreglado,y,x):
	var nodosVecinos = []

	if (y-2 > 0) and (y > 0):
		nodosVecinos.push_back([laberinto[y - 1][x],laberinto[y - 2][x],[y-1,x],"N"])
	
	if (y+2 < tamLabArreglado) and (y < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y + 1][x],laberinto[y + 2][x],[y+1,x],"S"])
		
	if (x+2 < tamLabArreglado) and (x < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y][x + 1],laberinto[y][x + 2],[y,x+1],"E"])
	
	if (x-2 > 0) and (x > 0):
		nodosVecinos.push_back([laberinto[y][x - 1],laberinto[y][x - 2],[y,x-1],"O"])
	
	return nodosVecinos

func obtenerNodosVecinos(laberinto,tamLabArreglado,y,x):
	var nodosVecinos = []

	if (y-1 > 0) and (y > 0):
		nodosVecinos.push_back([laberinto[y - 1][x],[y-1,x],"N"])
	
	if (y+1 < tamLabArreglado) and (y < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y + 1][x],[y+1,x],"S"])
		
	if (x+1 < tamLabArreglado) and (x < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y][x + 1],[y,x+1],"E"])
	
	if (x-1 > 0) and (x > 0):
		nodosVecinos.push_back([laberinto[y][x - 1],[y,x-1],"O"])
	
	return nodosVecinos


func generarCuartosEnLaberinto(laberinto,tamanoLaberinto,numCuartos):
	var tamLabArreglado = tamanoLaberinto-1
	for y in range(0,tamanoLaberinto):
		
		for x in range(0,tamanoLaberinto):
			if numCuartos <= 0:
				return
			
			if laberinto[y][x] == 0:
				var nodosVecinos = obtenerNodosVecinosConSalida(laberinto,tamLabArreglado,y,x)
				var nodosLlenos = 0
				
				var iter = 0
				for vecino in nodosVecinos:
					if vecino[0] == 1:
						nodosLlenos += 1
					iter += 1
					
				if nodosLlenos >= 2 and nodosVecinos.size() < 4:
					numCuartos -= 1
					
					laberinto[y][x] = 3
					for nodoVecino in nodosVecinos:
						laberinto[nodoVecino[2][0]][nodoVecino[2][1]] = 2
				else:
					continue

func eliminarCallejonesSinSalida(laberinto,tamanoLaberinto):
	var tamLabArreglado = tamanoLaberinto-1
	
	for y in range(0,tamanoLaberinto):
		for x in range(0,tamanoLaberinto):
			if laberinto[y][x] == 0:
				var nodosVecinos = obtenerNodosVecinosConSalida(laberinto,tamLabArreglado,y,x)
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

func generarLaberinto(tamanoLaberinto : int):
	var laberinto = []
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
	
	eliminarCallejonesSinSalida(laberinto,tamanoLaberinto)
	generarCuartosEnLaberinto(laberinto,tamanoLaberinto,5)
	
	return laberinto

func createLaberintoFisico(laberinto : Array, tamanoLaberinto: int):
	var x = 0
	var z = 0
	var startPos = Vector3(-1,0,-1)

	var PosicionInicial 
	var tamLabArreglado = tamanoLaberinto-1
	
	for contenedor in laberinto:
		for nodo in contenedor:
			var movingPos = startPos + Vector3(x,0,z)
			
			var nodosVecinos = obtenerNodosVecinos(laberinto,tamLabArreglado,z,x)
			
			if nodo == 1:
				var block = pared.instantiate()
				block.position = movingPos
				Paredes.add_child(block)
				
			elif nodo >= 2:
				var block = paredVacia.instantiate()
				block.position = movingPos
				Paredes.add_child(block)

				var miPiso = piso.instantiate()
				miPiso.position = movingPos + Vector3(0,-.5,0)
				Piso.add_child(miPiso)
				
				for nodoVecino in nodosVecinos:
					if not (laberinto[nodoVecino[1][0]][nodoVecino[1][1]] >= 2):
						continue
					if nodoVecino[2] == "N":
						block.find_child("Frente").queue_free()
					elif nodoVecino[2] == "S":
						block.find_child("Detras").queue_free()
					elif nodoVecino[2] == "E":
						block.find_child("Derecha").queue_free()
					elif nodoVecino[2] == "O":	
						block.find_child("Izquierda").queue_free()
						
				if nodo == 3:
					for nodoVecino in nodosVecinos:
						if not (laberinto[nodoVecino[1][0]][nodoVecino[1][1]] == 0):
							continue
					
						if nodoVecino[2] == "N":
							block.find_child("Frente").queue_free()
							break
						elif nodoVecino[2] == "S":
							block.find_child("Detras").queue_free()
							break
						elif nodoVecino[2] == "E":
							block.find_child("Derecha").queue_free()
							break
						elif nodoVecino[2] == "O":	
							block.find_child("Izquierda").queue_free()
							break
			else:
				var block = piso.instantiate()
				block.position = movingPos + Vector3(0,-.5,0)
				Piso.add_child(block)
			x += 1
		z += 1
		x = 0



func _ready() -> void:
	await(get_tree().create_timer(.05).timeout)
	var tamanoLaberinto = 25
	var laberintoArray = generarLaberinto(tamanoLaberinto)
	createLaberintoFisico(laberintoArray,tamanoLaberinto)
