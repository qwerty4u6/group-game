extends Camera2D

var player

func _ready():
	player = get_parent().get_node("Player")
	$ColorRect.show()

func _process(delta):
	position = player.position
