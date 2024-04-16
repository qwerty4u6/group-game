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
@onready var resources = preload("res://resources/current_characters.tres")
var team_resources = []
var enemy_resources = []

@onready var anim_player = get_node("CanvasLayer/AnimationPlayer")

var team = []
var team_sprites = []
var team_stat_displays = []
var enemies = []
var enemy_sprites = []
var enemy_stat_displays = []
var characters = []
var current_turn = -1
var current_character = null
var selecting = false
var select_target = null

signal done_fading_in
signal done_fading_out
signal textbox_closed
signal done_with_enemy_turns

func _ready():
	get_node("CanvasLayer/ColorRect").show()
	$ActionBox.to_empty_box()
	
	for member in resources.team:
		team_resources.push_back(load(member))
	for member in resources.enemies:
		enemy_resources.push_back(load(member))
	
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
		enemy_stat_displays.push_front(disp)
		$Enemies.get_children()[i].set_disp(disp)
		
		var char = battle_character_scene.instantiate() 
		add_child(char)
		char.init(disp)
		char.position = team_member_positions[i + 3]
		var sprite = load(enemy_sprites[i][0]).instantiate()
		char.add_child(sprite)
		sprite.play("idle")
		sprite.flip_h = enemy_sprites[i][1]
	
	anim_player.play("fade_in")
	await done_fading_in
	$ActionBox.show_text(resources.appear_text)
	await $ActionBox.textbox_closed
	next_turn()

func calc_skill_weights(skills, mana):
	var possible_skills = []
	for skill in skills:
		if mana >= skill.mana_cost:
			possible_skills.push_back(skill)
	
	var mana_costs = []
	for skill in possible_skills:
		mana_costs.push_back(ceil(sqrt(skill.mana_cost) + 0.001))
	
	var lcd = 1
	for cost in mana_costs:
		lcd *= cost
	
	var weight_values = []
	for cost in mana_costs:
		weight_values.push_back(lcd / cost)
	
	var skill_pool = []
	for i in weight_values.size():
		for a in weight_values[i]:
			skill_pool.push_back(i)
	
	return skill_pool

func enemy_turn(enemy):
	var skill = enemy.skills.pick_random()
	print(calc_skill_weights(enemy.skills, enemy.mana))
	var target = ""
	if skill.target == "team":
		target = team_stat_displays.pick_random()
	elif skill.target == "enemy":
		target = enemy_stat_displays.pick_random()
	
	enemy.disp.take_mana(skill.mana_cost)
	if skill.applies[0] == "damage":
		target.damage((enemy.damage + skill.applies[1]) * skill.applies[2])
	elif skill.applies[0] == "heal":
		target.damage(-skill.applies[1])
	
	print()
	
	return skill.message % [enemy.name_text, target.res.name_text] #fix this

func next_turn():
	current_turn += 1
	if current_turn >= team.size():
		for enemy in $Enemies.get_children():
			if enemy.hp == 0:
				continue
			$ActionBox.show_text(enemy_turn(enemy))
			await $ActionBox.textbox_closed
		current_turn = 0
	
	current_character = characters[current_turn % 6]
	$ActionBox.to_action_box(current_character)

func selected_display():
	for disp in members:
		if disp.hovering == true:
			return disp
	return null

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		emit_signal("done_fading_in")
	elif anim_name == "fade_out":
		emit_signal("done_fading_out")

