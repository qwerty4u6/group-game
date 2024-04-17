extends Panel

@onready var battle = get_parent()
@onready var text_box = get_node("MarginContainer/TextBox")
@onready var action_box = get_node("MarginContainer/ActionBox")
@onready var back_box = get_node("MarginContainer/BackBox")
@onready var empty_box = get_node("MarginContainer/EmptyBox")
@onready var text_box_label = text_box.get_node("MarginContainer/Label")
@onready var skill_buttons = action_box.get_node("MarginContainer/MainContainer/SkillsContainer").get_children()

var target = null

var button_hovered = null

signal text_done_displaying
signal textbox_closed
signal selected

func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if text_box_label.visible_characters >= text_box_label.text.length() + 1:
			text_box.hide()
			action_box.show()
			emit_signal("textbox_closed")
			text_box_label.visible_characters = 0
	elif Input.is_action_just_pressed("move_up"):
		print(battle.selected_display())
	elif Input.is_action_just_pressed("move_down"):
		get_tree().change_scene_to_file("res://scenes/battle.tscn")

func to_textbox():
	text_box.show()
	action_box.hide()
	back_box.hide()
	empty_box.hide()
	
	for button in skill_buttons:
		button.clickable = false

func to_action_box(character = null):
	text_box.hide()
	action_box.show()
	back_box.hide()
	empty_box.hide()
	
	for button in skill_buttons:
		button.clickable = true
	
	var skills = character.skills
	for i in 4:
		if i >= skills.size():
			skill_buttons[i].init(i)
		else:
			skill_buttons[i].init(i, skills[i], character.mana)
	
	if character != null:
		action_box.get_node("MarginContainer/MainContainer/MiscContainer/NameLabel").text = character.name_text
		action_box.get_node("MarginContainer/MainContainer/MiscContainer/TextureRect").texture = character.texture

func to_back_box():
	text_box.hide()
	action_box.hide()
	back_box.show()
	empty_box.hide()
	
	for button in skill_buttons:
		button.clickable = false

func to_empty_box():
	text_box.hide()
	action_box.hide()
	back_box.hide()
	empty_box.show()
	
	for button in skill_buttons:
		button.clickable = false

func show_text(text):
	to_textbox()
	text_box.get_node("NextLabel").hide()
	
	text_box_label.get_node("Timer").set_paused(false)
	text_box_label.visible_characters = 0
	text_box_label.get_node("Timer").start()
	text_box_label.text = text
	
	await text_done_displaying
	text_box_label.get_node("Timer").set_paused(true)
	text_box.get_node("NextLabel").show()
	$AnimationPlayer.play("next arrow")

func _on_timer_timeout():
	text_box_label.visible_characters += 1
	if text_box_label.visible_characters == text_box_label.text.length() + 1:
		emit_signal("text_done_displaying")

func _on_back_pressed():
	to_action_box()
	battle.selecting = false

func prepare_skill(i):
	var disp = battle.selected_display()
	var character = battle.current_character
	if character.skills.size() <= i:
		return
	var skill = character.skills[i]
	if character.mana < skill.mana_cost:
		return
	
	to_back_box()
	battle.selecting = true
	battle.select_target = skill.target
	await selected
	battle.selecting = false
	disp = battle.selected_display()
	disp.stop_hover()
	
	battle.current_character.disp.take_mana(skill.mana_cost)
	if skill.applies[0] == "damage":
		disp.damage((character.damage + skill.applies[1]) * skill.applies[2])
	show_text(skill.message % [character.name_text, target.res.name_text])
	await textbox_closed
	battle.next_turn()
