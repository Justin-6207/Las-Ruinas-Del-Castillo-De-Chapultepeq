extends Control

@onready var Contenedor = $"HFlowContainer"
var botones = []


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Contenedor.get_children():
		botones.push_back(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if G.MiInventario == null:
		return
	
	var iter = 0
	for objStr in G.MiInventario:
		if objStr != "":
			botones[iter].icon = load(G.Objetos[objStr].icono)
		iter += 1
		
