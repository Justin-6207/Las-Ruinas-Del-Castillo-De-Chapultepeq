class_name  PathfindingClass

var matrizAdyacencia
var matrizLaberinto
var pisosLaberinto

func genKey(y,x):
	return str(y)+"-"+str(x)
	
func posFromKey(key : String):
	var items = key.split("-")
	var y = int(items[0])
	var x = int(items[1])
	
	var objeto = pisosLaberinto[y][x]
	return (objeto.global_position * Vector3(1,0,1))

func nodosVecinos(y : int,x : int):
	var nodosVecinos = []
	var tamLabArreglado = matrizLaberinto.size()-1
	
	if (y-1 > 0) and (y > 0):
		nodosVecinos.push_back([matrizLaberinto[y - 1][x],genKey(y-1,x)])
	
	if (y+1 < tamLabArreglado) and (y < tamLabArreglado):
		nodosVecinos.push_back([matrizLaberinto[y + 1][x],genKey(y+1,x)])
		
	if (x+1 < tamLabArreglado) and (x < tamLabArreglado):
		nodosVecinos.push_back([matrizLaberinto[y][x + 1],genKey(y,x+1)])
	
	if (x-1 > 0) and (x > 0):
		nodosVecinos.push_back([matrizLaberinto[y][x - 1],genKey(y,x-1)])
	
	return nodosVecinos

func generarMatrizAdyacencia():
	for y in range(0,matrizLaberinto.size()):
		for x in range(0,matrizLaberinto.size()):
			
			var valorMiNodo = matrizLaberinto[y][x]
			if valorMiNodo == 1:
				continue
				
			var matVc = {}
			var nodosVecinos = nodosVecinos(y,x)
			
			for nodo in nodosVecinos:
				if (valorMiNodo == 0 or valorMiNodo == 3) and nodo[0] == 0:
					matVc[nodo[1]] = 1
					
				elif valorMiNodo == 0 and nodo[0] == 3:
					matVc[nodo[1]] = 1
					
				elif valorMiNodo == 3 and nodo[0] == 2:
					matVc[nodo[1]] = 1
					
				elif valorMiNodo == 2 and nodo[0] == 3:
					matVc[nodo[1]] = 1	
					
				elif valorMiNodo == 2 and nodo[0] == 2:
					matVc[nodo[1]] = 1

					
			matrizAdyacencia[genKey(y,x)] = matVc

func encontrarCamino(PosicionInicial,PosicionFinal):
	var minDist = {}
	var padre = {}
	var valorMaximo = 9999
	
	for key in matrizAdyacencia:
		minDist[key] = valorMaximo
		padre[key] = "NULL"
	
	minDist[PosicionInicial] = 0;
	
	while minDist[PosicionFinal] >= valorMaximo:
		for y in range(0,matrizLaberinto.size()):
			for x in range(0,matrizLaberinto.size()):
				var nodoActual = genKey(y,x)
				if not matrizAdyacencia.has(nodoActual):
					continue
					
				if minDist[nodoActual] >= valorMaximo:
					continue
				var listaAdyacencia = matrizAdyacencia[nodoActual]
				for nodoMeta in listaAdyacencia:
					var peso = listaAdyacencia[nodoMeta]
					if (minDist[nodoActual] + peso) < minDist[nodoMeta]:
						minDist[nodoMeta] = minDist[nodoActual] + peso
						padre[nodoMeta] = nodoActual
		
	if minDist[PosicionFinal] >= valorMaximo:
		return
	
	var camino = []
	var curr = PosicionFinal
	
	while curr != "NULL":
		camino.append(curr)
		curr = padre[curr]
	camino.reverse()
	
	var caminoFisico = []
	for posLocal in camino:
		caminoFisico.append(posFromKey(posLocal))
		
	return caminoFisico
	
func _init(matrizMapa: Array, pisLab: Array):
	matrizLaberinto = matrizMapa
	pisosLaberinto = pisLab
	matrizAdyacencia = {}
	generarMatrizAdyacencia()

				
