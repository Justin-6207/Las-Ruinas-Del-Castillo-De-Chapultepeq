extends Node3D
@onready var MI3D = $MeshInstance3D
@onready var CS3D = $MeshInstance3D/StaticBody3D/CollisionShape3D
@onready var ContenedorSonidos = $Sonidos

@export var Abierta = false 

var sonidos = {}

func usar():
	if Abierta:
		sonidos["CerrandoPuerta"].play()
	else:
		sonidos["AbriendoPuerta"].play()	
	Abierta = not Abierta

func _ready():
	for sonido in ContenedorSonidos.get_children():
		sonidos[sonido.name] = sonido

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale = Vector3(1,.5,1)
	
	var mat = MI3D.material_override.duplicate()
	MI3D.material_override = mat
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	if Abierta:
		CS3D.disabled = true 
		mat.albedo_color.a = 0.5
	else:
		CS3D.disabled = false
		mat.albedo_color.a = 1
	
