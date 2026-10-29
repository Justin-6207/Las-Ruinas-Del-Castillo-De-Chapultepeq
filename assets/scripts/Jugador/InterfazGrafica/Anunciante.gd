extends Label

@export var Anuncio = ""
var alpha = 0

func _ready():
	G.Anunciante = self

func _process(delta):
	if Anuncio != "" and Anuncio != null:
		alpha = 1
		text = Anuncio
		Anuncio = ""
		find_child("Notificacion").play()
	
	alpha = clamp(alpha - delta * .25,0,1)
	self.modulate.a = alpha
