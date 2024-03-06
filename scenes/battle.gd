extends Control

const team_member_positions = [
	Vector2(308, 592),
	Vector2(252, 660),
	Vector2(340, 708),
	Vector2(892, 592),
	Vector2(948, 660),
	Vector2(860, 708),
]

var members = []

@onready var data_container = preload("res://scenes/character_data_container.tscn")
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
var team = []
var enemies = []
var characters = []
var current_turn = -1
var current_character = null
var selecting = false
var select_target = null

signal textbox_closed

func _ready():
	for member in team_resources:                #   add character data to team and enemies nodes
		var new = data_container.instantiate()
		new.type = "team"
		new.init(member)
		$Team.add_child(new)
		characters.push_back(new)
	team = $Team.get_children()
	
	for member in enemy_resources:
		var new = data_container.instantiate()
		new.type = "enemy"
		new.init(member)
		$Enemies.add_child(new)
		characters.push_back(new)
	enemies = $Enemies.get_children()
	
	
	var offset = (806 - team.size() * 138) / 2
	for i in team.size():
		var disp = char_stat_display_scene.instantiate()
		members.push_back(disp)
		add_child(disp)
		disp.init(team[i])
		disp.position = Vector2(6, offset + i * 138)
		
		var char = battle_character_scene.instantiate() 
		add_child(char)
		char.init(disp)
		char.position = team_member_positions[i]
	
	offset = (806 - enemies.size() * 138) / 2
	for i in enemies.size():
		var disp = char_stat_display_scene.instantiate()
		members.push_back(disp)
		add_child(disp)
		disp.init(enemies[i])
		disp.position = Vector2(984, offset + i * 138)
		
		var char = battle_character_scene.instantiate() 
		add_child(char)
		char.init(disp)
		char.position = team_member_positions[i + 3]
	
	$ActionBox.show_text("blabla appeared text")
	await $ActionBox.textbox_closed
	next_turn()

func _input(event):
	pass

func next_turn():
	current_turn += 1
	print(current_turn)
	if current_turn >= team.size():
		current_turn = 0
	current_character = characters[current_turn % 6]
	$ActionBox.to_action_box(current_character)

func selected_display():
	for disp in members:
		if disp.hovering == true:
			return disp
	return null
