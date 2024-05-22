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

@onready var global = get_tree().get_root().get_node("Global")
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
var state = "battle"

signal done_fading_in
signal done_fading_out
signal textbox_closed
signal done_with_enemy_turns
	
func _ready():
	get_node("CanvasLayer/ColorRect").show()
	$ActionBox.to_empty_box()
	
	$ActionBox.flee_button.skippable = resources.fleeable
	
	for member in resources.team:
		team_resources.push_back(load(member))
	var i5 = 0
	for member in resources.enemies:
		if i5 != 0:
			enemy_resources.push_back(load(member))
		i5 += 1
	
	var new_team_required = global.get_team() == null
	
	var j = 0
	for member in team_resources:
		var new
		if new_team_required:
			new = data_container.instantiate()
			new.type = "team"
			new.init(member)
		else:
			new = global.get_team()[j].instantiate()
		$Team.add_child(new)
		characters.push_back(new)
		team_sprites.push_back(new.sprite)
		j += 1
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
		$Team.get_children()[i].set_disp(disp)
		
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
	
	for member in team_stat_displays:
		if member.res.hp <= 0:
			member.set_hp(1)
	
	if global.should_heal:
		for disp in team_stat_displays:
			disp.heal(999)
			global.should_heal = false
	
	anim_player.play("fade_in")
	await done_fading_in
	$ActionBox.show_text(resources.enemies[0])
	await $ActionBox.textbox_closed
	next_turn()

func calc_level_buff(lvl):
	var buffs = []
	if fmod((lvl + 4.0) / 6.0, 1) == 0:
		buffs.push_back(1)
	else:
		buffs.push_back(0)
	if fmod((lvl + 2.0) / 6.0, 1) == 0:
		buffs.push_back(1)
	else:
		buffs.push_back(0)
	if fmod((lvl + 1.0) / 6.0, 1) == 0:
		buffs.push_back(1)
	else:
		buffs.push_back(0)
	if fmod(lvl / 3.0, 1) == 0:
		buffs.push_back(1)
	else:
		buffs.push_back(0)
	if fmod((lvl + 5.0) / 12.0, 1) == 0:
		buffs.push_back(1)
	else:
		buffs.push_back(0)
	if fmod((lvl - 1.0) / 12.0, 1) == 0:
		buffs.push_back(1)
	else:
		buffs.push_back(0)
	return buffs

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
	var skill = enemy.skills[calc_skill_weights(enemy.skills, enemy.mana).pick_random()]
	var target = {"dead": true}
	if skill.target == "team":
		while target.dead:
			target = team_stat_displays.pick_random()
	elif skill.target == "enemy":
		while target.dead:
			target = enemy_stat_displays.pick_random()
	
	enemy.disp.take_mana(skill.mana_cost)
	if skill.applies[0] == "damage":
		target.damage((enemy.damage + skill.applies[1] - target.res.defense) * skill.applies[2])
	elif skill.applies[0] == "heal":
		target.heal(-skill.applies[1])
	
	return skill.message % [enemy.name_text, target.res.name_text]

func next_turn():
	current_turn += 1
	
	var enem_amt = 0
	for character in characters:
		if enemies.has(character):
			enem_amt += 1
	if enem_amt == 0:
		win()
		return
	
	var team_size = 0
	for member in team:
		if member.hp > 0:
			team_size += 1
	if current_turn >= team_size:
		for enemy in $Enemies.get_children():
			if enemy.disp.dead:
				continue
			$ActionBox.show_text(enemy_turn(enemy))
			await $ActionBox.textbox_closed
		current_turn = 0
		for character in characters:
			character.disp.take_mana(-1)
		
		var team_amt = 0
		for character in characters:
			if team.has(character):
				team_amt += 1
		if team_amt == 0:
			lose()
			return
	
	current_character = characters[current_turn % 6]
	$ActionBox.to_action_box(current_character)

func lose():
	$ActionBox.show_text("Your party is too weak to continue..")
	await $ActionBox.textbox_closed
	$ActionBox.queue_free()

func calc_next_level_requirement(lvl):
	return floor(pow(lvl - 1, 1.5) + 5)

func win():
	var xp = 0
	for enemy in enemies:
		xp += enemy.xp_reward
	$ActionBox.show_text("Your party won and got " + str(xp) + " XP!")
	await $ActionBox.textbox_closed
	
	for member in team:
		member.xp += xp
		var req = calc_next_level_requirement(member.level)
		var leveled_up = false
		while member.xp >= req:
			member.level += 1
			member.xp -= req
			leveled_up = true
			
			var buff = calc_level_buff(member.level)
			if buff[0] == 1 || buff[1] == 1 || buff[2] == 1:
				member.max_hp += 1
				member.hp += 1
			elif buff[3] == 1:
				member.max_mana += 1
				member.mana += 1
			elif buff[4] == 1:
				member.damage += 1
			elif buff[5] == 1:
				member.defense += 1
		if leveled_up:
			member.disp.get_node("LevelLabel").text = "lvl. " + str(member.level)
			$ActionBox.show_text(member.name_text + " leveled up to level " + str(member.level) + "!")
			await $ActionBox.textbox_closed
	
	global.store_team($Team.get_children())
	get_tree().change_scene_to_packed(global.get_main())

func good_flee():
	$ActionBox.show_text("Your party ran from the battle..")
	await $ActionBox.textbox_closed
	global.store_team($Team.get_children())
	get_tree().change_scene_to_packed(global.get_main())
	
func bad_flee():
	$ActionBox.show_text("Flee attempt failed..")
	await $ActionBox.textbox_closed
	next_turn()

func selected_display():
	for disp in members:
		if disp.is_hovering():
			return disp
	return null

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		emit_signal("done_fading_in")
	elif anim_name == "fade_out":
		emit_signal("done_fading_out")

