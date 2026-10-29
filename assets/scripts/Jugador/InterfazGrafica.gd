extends Control

@onready var Contenedor = $"HFlowContainer"
@onready var ContadorLlaves = $"ContadorLlaves"
@onready var BarraStamina = $"BarraStamina"
@onready var BarraStaminaLlena = $"BarraStamina/Lleno"
@onready var BarraStaminaRestante = $"BarraStamina/Restante"
var botones = []


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Contenedor.get_children():
		botones.push_back(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if G.MiPersonaje == null:
		return
	
	ContadorLlaves.text = "LLAVES RECOLECTADAS: " + str(G.MiPersonaje.llavesRecolectadas)
	var iter = 0
	for objStr in G.MiPersonaje.elInventario:
		if objStr != "":
			botones[iter].icon = load(G.DataObjetos[objStr].icono)
		else:
			botones[iter].icon = null	
		iter += 1
	
	BarraStaminaRestante.text = "STAMINA: " + str(String.num(G.MiPersonaje.stamina, 1)) + "/" + str(G.MiPersonaje.maxStamina)
	BarraStaminaLlena.scale = Vector2(G.MiPersonaje.stamina/G.MiPersonaje.maxStamina,1)
		
