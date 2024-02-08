extends Control # 390, 270

var team_resources
var members = []

@onready var char_stat_display_scene = preload("res://scenes/char_stat_display.tscn")

signal textbox_closed

func _ready():
	team_resources = [
		load("res://resources/player characters/ninja.tres"),
		load("res://resources/player characters/ninja2.tres"),
		load("res://resources/player characters/ninja3.tres")
	]
	var offset = (806 - team_resources.size() * 138) / 2
	var i = 0
	for member in team_resources.size():
		var disp = char_stat_display_scene.instantiate()
		members.push_back(disp)
		add_child(disp)
		disp.init(team_resources[i])
		
		disp.position = Vector2(6, offset + i * 138)
		i += 1
	
	team_resources = [
		load("res://resources/enemy characters/placeholder enemy.tres"),
		load("res://resources/enemy characters/placeholder enemy.tres"),
		load("res://resources/enemy characters/placeholder enemy.tres")
	]
	i = 0
	for member in team_resources.size():
		var disp = char_stat_display_scene.instantiate()
		members.push_back(disp)
		add_child(disp)
		disp.init(team_resources[i])
		
		disp.position = Vector2(984, offset + i * 138)
		i += 1
	
	$ActionBox.to_action_box()

func _input(event):
	if event.is_action_pressed("move_up"):
		$ActionBox.show_text("helgssghdghdhdsghlo")
		await $ActionBox.textbox_closed
		$ActionBox.show_text("works i think")
		await $ActionBox.textbox_closed
		$ActionBox.show_text("yipeeee")
