extends Node3D
@onready var MI3D = $MeshInstance3D
@export var Abierta = false 

func usar():
	Abierta = not Abierta

func _ready():
	G.MisInteraccionables.push_back(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale = Vector3(1,.5,1)
	
	var mat = MI3D.material_override 
	mat = mat.duplicate()
	MI3D.material_override = mat
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	if Abierta:
		mat.albedo_color.a = 0.5
	else:
		mat.albedo_color.a = 1
	
