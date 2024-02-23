extends Control

var members = []

@onready var char_stat_display_scene = preload("res://scenes/char_stat_display.tscn")
@onready var battle_character_scene = preload("res://scenes/battle_character.tscn")

@onready var team_resources = [
	load("res://resources/player characters/ninja.tres"),
	load("res://resources/player characters/ninja2.tres"),
	load("res://resources/player characters/ninja3.tres")
]
@onready var enemy_resources = [
	load("res://resources/enemy characters/placeholder enemy.tres"),
	load("res://resources/enemy characters/placeholder enemy.tres"),
	load("res://resources/enemy characters/placeholder enemy.tres")
]
var enemies = []
var turn_current_character = null

signal textbox_closed

func _ready():
	var team_member_positions = [
		Vector2(308, 592),
		Vector2(252, 660),
		Vector2(340, 708),
	]
	var offset = (806 - team_resources.size() * 138) / 2
	var i = 0
	for member in team_resources.size():
		var disp = char_stat_display_scene.instantiate()
		members.push_back(disp)
		add_child(disp)
		disp.init(team_resources[i])
		disp.position = Vector2(6, offset + i * 138)
		
		var char = battle_character_scene.instantiate() 
		add_child(char)
		char.init(disp)
		char.position = team_member_positions[i]
		
		i += 1
	
	team_member_positions = [
		Vector2(892, 592),
		Vector2(948, 660),
		Vector2(860, 708),
	]
	i = 0
	for member in enemy_resources.size():
		var disp = char_stat_display_scene.instantiate()
		members.push_back(disp)
		add_child(disp)
		disp.init(enemy_resources[i])
		disp.position = Vector2(984, offset + i * 138)
		
		var char = battle_character_scene.instantiate() 
		add_child(char)
		char.init(disp)
		char.position = team_member_positions[i]
		
		i += 1
	
	$ActionBox.to_action_box()

func _input(event):
	if event.is_action_pressed("move_up"):
		$ActionBox.show_text("helgssghdghdhdsghlo")
		await $ActionBox.textbox_closed
		$ActionBox.show_text("works i think")
		await $ActionBox.textbox_closed
		$ActionBox.show_text("yipeeee")
