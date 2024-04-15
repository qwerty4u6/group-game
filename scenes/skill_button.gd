extends Area2D

var skill

func _ready():
	pass

func init(init_skill):
	skill = init_skill

func darken():
	$Darken.show()

func lighten():
	$Darken.hide()
