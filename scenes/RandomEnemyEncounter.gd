extends Area2D

@onready var main = get_parent().get_parent()

@export var enemies = []
@export var message = "attack message"
@export var freq = 750.0

func calc(dist):
	if fmod(dist, freq) == freq - 1:
		var player = main.get_node("Player")
		player.interacting_with = null
		player.can_walk = false
		main.start_battle(main.team, enemies, message)
	return name
