extends Node3D

@export var pared: PackedScene
@export var piso: PackedScene

@onready var Paredes = $"Paredes"
@onready var Piso = $"Piso"
@onready var Objetos = $"Objetos"
# Called when the node enters the scene tree for the first time.

func obtenerNodosVecinos(laberinto,tamLabArreglado,x,y):
	var nodosVecinos = []
	
	if (x+2 < tamLabArreglado) and (x < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y][x + 1],laberinto[y][x + 2],[y,x+1]])
	
	if (x-2 > 0) and (x > 0):
		nodosVecinos.push_back([laberinto[y][x - 1],laberinto[y][x - 2],[y,x-1]])
	
	if (y+2 < tamLabArreglado) and (y < tamLabArreglado):
		nodosVecinos.push_back([laberinto[y + 1][x],laberinto[y + 2][x],[y+1,x]])
		
	if (y-2 > 0) and (y > 0):
		nodosVecinos.push_back([laberinto[y - 1][x],laberinto[y - 2][x],[y-1,x]])
	
	return nodosVecinos
	

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
		
		print("")
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

	for y in range(0,tamanoLaberinto):
		for x in range(0,tamanoLaberinto):
			if laberinto[y][x] == 0:
				var nodosVecinos = obtenerNodosVecinos(laberinto,tamLabArreglado,x,y)
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
				
	laberinto[0][0] = 1
	return laberinto

func createLaberinto(laberintoArray : Array):
	var x = 0
	var z = 0
	var startPos = Vector3(-1,0,-1)
	
	for contenedor in laberintoArray:
		for nodo in contenedor:
			if nodo == 1:
				var block = pared.instantiate()
				block.position = startPos + Vector3(x,0,z)
				Paredes.add_child(block)
			else:
				var block = piso.instantiate()
				block.position = startPos + Vector3(x,-.5,z)
				Piso.add_child(block)
			x += 1
		z += 1
		x = 0

func _ready() -> void:
	var laberintoArray = generarLaberinto(25)
	createLaberinto(laberintoArray)
