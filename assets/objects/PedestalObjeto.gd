extends Node3D

@export var ObjetoContenido: String 
@onready var SpriteObjeto = $"SpriteObjeto"
var invObj = Globales.Objetos
var botones = []
var invPers

# Called when the node enters the scene tree for the first time.
func _ready():
	invPers = Globales.MiPersonaje.miInventario

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ObjetoContenido != "":
			SpriteObjeto.icon = load(invObj[ObjetoContenido].icono)
