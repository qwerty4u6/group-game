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
		"name": "blahblah",
		"level": 4,
		"max_hp": 16,
		"max_mana": 10,
	}
]

var char_stat_displays = []

@onready var char_stat_display_scene = preload("res://scenes/char_stat_display.tscn")

func _ready():
	var i = 0
	for member in team_members:
		var disp = char_stat_display_scene.instantiate()
		char_stat_displays.push_back(disp)
		add_child(disp)
		
		disp.get_node("NameLabel").text = member.name
		disp.get_node("LevelLabel").text = "lvl. " + str(member.level)
		var hp = member.max_hp
		var hp_bar = disp.get_node("HealthBar")
		hp_bar.max_value = hp
		hp_bar.value = hp
		hp_bar.get_node("Label").text = str(hp)
		#disp.get_node("ManaBar/Label").text = str(member.max_mana)
		disp.position.y = i * 120
		i += 1
	
