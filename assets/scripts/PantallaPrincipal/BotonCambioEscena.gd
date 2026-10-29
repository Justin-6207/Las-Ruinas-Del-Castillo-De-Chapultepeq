extends Button
@export var caminoHaciaEscena = ""

func onpressed():
	print("CAMBIAR ESCENAS")
	print(caminoHaciaEscena)
	get_tree().change_scene_to_file(caminoHaciaEscena)

func _ready():
	pressed.connect(onpressed)
