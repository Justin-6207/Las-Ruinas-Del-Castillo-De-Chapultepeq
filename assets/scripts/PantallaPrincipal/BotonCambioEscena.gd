extends Button
@export var caminoHaciaEscena = ""

func onpressed():
	get_tree().change_scene_to_file(caminoHaciaEscena)

func _ready():
	pressed.connect(onpressed)
