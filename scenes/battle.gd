extends Control

static var team_members = [
	{
		"name": "plhldr 1",
		"level": 8,
		
		"max_hp": 18,
		"hp": 18,
		"max_mana": 12,
		"mana": 12,
	},
	{
		"name": "plhldr 2",
		"level": 5,
		
		"max_hp": 15,
		"hp": 15,
		"max_mana": 10,
		"mana": 10,
	},
	{
		"name": "blahblah",
		"level": 4,
		
		"max_hp": 16,
		"hp": 16,
		"max_mana": 10,
		"mana": 10,
	}
]

var char_stat_displays = []

@onready var char_stat_display_scene = preload("res://scenes/char_stat_display.tscn")

func _ready():
	var i = 0
	var offset = (806 - team_members.size() * 120) / 2
	for member in team_members:
		var disp = char_stat_display_scene.instantiate()
		char_stat_displays.push_back(disp)
		add_child(disp)
		
		disp.get_node("NameLabel").text = member.name
		disp.get_node("LevelLabel").text = "lvl. " + str(member.level)
		disp.set_max_hp(member.max_hp)
		disp.set_hp(member.hp)
		disp.set_max_mana(member.max_mana)
		disp.set_mana(member.mana)
		disp.position = Vector2(6, offset + i * 120)
		i += 1
