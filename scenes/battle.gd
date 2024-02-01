extends Control

var team_resources
var members = []

@onready var char_stat_display_scene = preload("res://scenes/char_stat_display.tscn")

func _ready():
	team_resources = [
		load("res://resources/player characters/ninja.tres"),
		load("res://resources/player characters/ninja2.tres"),
		load("res://resources/player characters/ninja3.tres")
	]
	var i = 0
	var offset = (806 - team_resources.size() * 120) / 2
	for member in team_resources.size():
		var disp = char_stat_display_scene.instantiate()
		members.push_back(disp)
		add_child(disp)
		disp.init(team_resources[i])
		
		disp.position = Vector2(6, offset + i * 120)
		i += 1

func _input(event):
	if event.is_action_pressed("move_up"):
		pass
