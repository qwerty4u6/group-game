extends Control

const team_member_positions = [
	Vector2(360, 592),
	Vector2(300, 660),
	Vector2(388, 708),
	Vector2(840, 592),
	Vector2(900, 660),
	Vector2(812, 708),
]

var members = []

@onready var data_container = preload("res://scenes/character_data_container.tscn")
@onready var char_stat_display_scene = preload("res://scenes/char_stat_display.tscn")
@onready var battle_character_scene = preload("res://scenes/battle_character.tscn")

@onready var team_resources = [
	load("res://resources/player characters/isana.tres"),
	load("res://resources/player characters/kousuke.tres"),
	load("res://resources/player characters/yuuna.tres")
]
@onready var enemy_resources = [
	load("res://resources/enemy characters/fisherman.tres"),
	load("res://resources/enemy characters/fisherman.tres"),
	load("res://resources/enemy characters/fisherman.tres"),
]
var team = []
var team_sprites = []
var team_stat_displays = []
var enemies = []
var enemy_sprites = []
var characters = []
var current_turn = -1
var current_character = null
var selecting = false
var select_target = null

signal textbox_closed

func _ready():
	for member in team_resources:
		var new = data_container.instantiate()
		new.type = "team"
		new.init(member)
		$Team.add_child(new)
		characters.push_back(new)
		team_sprites.push_back(new.sprite)
	team = $Team.get_children()
	
	for member in enemy_resources:
		var new = data_container.instantiate()
		new.type = "enemy"
		new.init(member)
		$Enemies.add_child(new)
		characters.push_back(new)
		enemy_sprites.push_back([new.sprite, new.flip_h])
	enemies = $Enemies.get_children()
	
	
	var offset = (806 - team.size() * 138) / 2
	for i in team.size():
		var disp = char_stat_display_scene.instantiate()
		members.push_back(disp)
		add_child(disp)
		disp.init(team[i])
		disp.position = Vector2(6, offset + i * 138)
		team_stat_displays.push_front(disp)
		
		var char = battle_character_scene.instantiate() 
		add_child(char)
		char.init(disp)
		char.position = team_member_positions[i]
		var sprite = load(team_sprites[i]).instantiate()
		char.add_child(sprite)
		sprite.play("idle")
	
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
		var sprite = load(enemy_sprites[i][0]).instantiate()
		char.add_child(sprite)
		sprite.play("idle")
		sprite.flip_h = enemy_sprites[i][1]
	
	$ActionBox.show_text("blabla appeared text")
	await $ActionBox.textbox_closed
	next_turn()

func _input(event):
	pass

func next_turn():
	current_turn += 1
	if current_turn >= team.size():
		for enemy in $Enemies.get_children():
			if enemy.hp == 0:
				continue
			var skill = enemy.skills.pick_random()
			print(skill)
			var target = team_stat_displays.pick_random()
			
			print(target, ", ", target.res.name_text)
			
			if skill.applies[0] == "damage":
				target.damage((enemy.damage + skill.applies[1]) * skill.applies[2])
			$ActionBox.show_text(skill.message % [enemy.name_text, target.res.name_text])
			await textbox_closed
		$ActionBox.show_text("hay")
		await $ActionBox.textbox_closed
		current_turn = 0
	
	current_character = characters[current_turn % 6]
	$ActionBox.to_action_box(current_character)

func selected_display():
	for disp in members:
		if disp.hovering == true:
			return disp
	return null
