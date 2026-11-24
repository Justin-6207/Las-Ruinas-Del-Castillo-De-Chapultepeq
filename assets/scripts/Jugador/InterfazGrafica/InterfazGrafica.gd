extends Control

@onready var Contenedor = $"HFlowContainer"
@onready var ContadorLlaves = $"ContadorLlaves"
@onready var BarraStamina = $"BarraStamina"
@onready var BarraStaminaLlena = $"BarraStamina/Lleno"
@onready var BarraStaminaRestante = $"BarraStamina/Restante"
@onready var Anunciante = $"Anunciante"
@onready var ContenedorMiniMapa = $"MiniMapa"
@onready var Puntero = $"MiniMapa/Puntero"

var botones = []
var panelesMiniMapa = []

var scaleMiniMap = .2

func moverMiniMapa():
	if G.LaberintoArray == null:
		return
	
	Puntero.rotation_degrees = G.rotJug()
	var mult = (ContenedorMiniMapa.size.x) * scaleMiniMap
	var multVectorMedio = Vector2(mult * .5,mult * .5)
	var PAE = G.MiPersonaje.get_meta("PosicionArrayEstimada")
	var vectorPAE = Vector2(PAE[1],PAE[0])
	vectorPAE = vectorPAE * mult
	
	for y in range(0,G.LaberintoArray.size()):
		for x in range(0,G.LaberintoArray.size()):
			var casilla = panelesMiniMapa[y][x]
			casilla.position = -vectorPAE + (Vector2(x,y) * mult) + multVectorMedio
	pass

func crearMiniMapa():
	while G.LaberintoArray == null:
		await get_tree().process_frame
		
	for y in range(0,G.LaberintoArray.size()):
		panelesMiniMapa.push_back([])
		for x in range(0,G.LaberintoArray.size()):
				var valorLaberinto = G.LaberintoArray[y][x]
				
				var casilla = Panel.new()
				casilla.size = ContenedorMiniMapa.size
				casilla.scale = Vector2(scaleMiniMap,scaleMiniMap)
				casilla.name = str(y) + "," + str(x)
				casilla.pivot_offset_ratio = Vector2(.5,.5)
				casilla.mouse_filter = Control.MOUSE_FILTER_IGNORE
				
				var new_stylebox = StyleBoxFlat.new()
				
				if valorLaberinto == 0:
					new_stylebox.bg_color = Color.DARK_GRAY
				elif valorLaberinto == 1:
					new_stylebox.bg_color = Color.DARK_RED
				elif valorLaberinto == 2 or valorLaberinto == 3:
					new_stylebox.bg_color = Color.STEEL_BLUE
				elif valorLaberinto == 4:
					new_stylebox.bg_color = Color.SADDLE_BROWN
				
				ContenedorMiniMapa.add_child(casilla)
				casilla.add_theme_stylebox_override("panel", new_stylebox)
				panelesMiniMapa[y].push_back(casilla)

func mostrarInventario():
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
			botones[iter].icon = load(GameData.Objetos[objStr].icono)
		else:
			botones[iter].icon = null
		iter += 1

func recolectablesYStatus():
	ContadorLlaves.text = "LLAVES RECOLECTADAS: " + str(G.MiPersonaje.llavesRecolectadas) + "/" + str(G.LlavesTotales)
	BarraStaminaRestante.text = "STAMINA: " + str(String.num(G.MiPersonaje.stamina, 1)) + "/" + str(G.MiPersonaje.maxStamina)
	BarraStaminaLlena.scale = Vector2(G.MiPersonaje.stamina/G.MiPersonaje.maxStamina,1)
	
	if G.MiPersonaje.staminaInfinita > 0:
		BarraStaminaLlena.color = Color("414141ff")
	else:
		BarraStaminaLlena.color = Color("0058b0")
	

func _ready():
	for i in Contenedor.get_children():
		botones.push_back(i)
	crearMiniMapa()

func _process(delta):
	if G.MiPersonaje == null:
		return
	moverMiniMapa()
	mostrarInventario()
	recolectablesYStatus()
