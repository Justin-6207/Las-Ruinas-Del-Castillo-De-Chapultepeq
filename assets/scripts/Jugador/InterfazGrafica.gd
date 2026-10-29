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
	
	ContadorLlaves.text = "LLAVES RECOLECTADAS: " + str(G.MiPersonaje.llavesRecolectadas) + "/" + str(G.LlavesTotales)
	var iter = 0
	for objStr in G.MiPersonaje.MiInventario:
		if G.MiPersonaje.espacioEnLaMano == iter:
			var new_stylebox = StyleBoxFlat.new()
			new_stylebox.bg_color = Color.GREEN
			new_stylebox.set_border_width_all(10)
			new_stylebox.border_color = Color.GREEN
			botones[iter].add_theme_stylebox_override("normal", new_stylebox)
		else:
			var new_stylebox = StyleBoxFlat.new()
			new_stylebox.bg_color = Color.WEB_GRAY
			botones[iter].add_theme_stylebox_override("normal", new_stylebox)
			
		if objStr != "":
			botones[iter].icon = load(G.ObjetosData[objStr].icono)
		else:
			botones[iter].icon = null	
		iter += 1
	
	BarraStaminaRestante.text = "STAMINA: " + str(String.num(G.MiPersonaje.stamina, 1)) + "/" + str(G.MiPersonaje.maxStamina)
	BarraStaminaLlena.scale = Vector2(G.MiPersonaje.stamina/G.MiPersonaje.maxStamina,1)
		
