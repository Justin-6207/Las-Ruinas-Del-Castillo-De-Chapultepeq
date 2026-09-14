extends Control

@onready var Contenedor = $"HFlowContainer"
var invObj = Globales.Objetos
var botones = []
var invPers


# Called when the node enters the scene tree for the first time.
func _ready():
	invPers = Globales.MiPersonaje.miInventario 
	for i in Contenedor.get_children():
		botones.push_back(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var iter = 0
	for objStr in invPers:
		if objStr != "":
			botones[iter].icon = load(invObj[objStr].icono)
		iter += 1
		
