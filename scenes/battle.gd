extends Control

static var team_members = [
	{
		"name": "plhldr 1",
		"level": 8,
		"max_hp": 18,
		"max_mana": 12,
	},
	{
		"name": "plhldr 2",
		"level": 5,
		"max_hp": 15,
		"max_mana": 10,
	},
	{
		"name": "blablablablablab",
		"level": 4,
		"max_hp": 16,
		"max_mana": 10,
	}
]

var char_stat_displays = []

@onready var char_stat_display_scene = preload("res://scenes/char_stat_display.tscn")

func _ready():
	var new_disp = char_stat_display_scene.instantiate()
	add_child(new_disp)
