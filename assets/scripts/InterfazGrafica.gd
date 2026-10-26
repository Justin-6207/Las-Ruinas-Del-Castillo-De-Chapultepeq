extends Control

@onready var Contenedor = $"HFlowContainer"
@onready var ContadorLlaves = $"ContadorLlaves"
var botones = []


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Contenedor.get_children():
		botones.push_back(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if G.MiInventario == null:
		return
	
	ContadorLlaves.text = "LLAVES RECOLECTADAS: " + str(G.MiPersonaje.llavesRecolectadas)
	var iter = 0
	for objStr in G.MiInventario:
		if objStr != "":
			botones[iter].icon = load(G.Objetos[objStr].icono)
		iter += 1
		
