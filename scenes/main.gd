extends Node

@onready var global = get_tree().get_root().get_node("Global")
@onready var current_characters = load("res://resources/current_characters.tres")
@onready var anim_player = get_node("CanvasLayer/AnimationPlayer")

var team = [
	"res://resources/player characters/isana.tres",
	"res://resources/player characters/kousuke.tres",
	"res://resources/player characters/yuuna.tres"
]

signal done_fading_in
signal done_fading_out

func _ready():
	get_node("CanvasLayer/TextBox").hide()
	get_node("CanvasLayer/ColorRect").show()
	anim_player.play("fade_in")
	await done_fading_in
	$Player.can_walk = true
	
	return
	start_battle(team, [
		"res://resources/enemy characters/friendly chef.tres"
	], "The sushi chef attacks!")

func start_battle(players, enemies, fleeable):
	anim_player.play("fade_out")
	await done_fading_out
	current_characters.team = players
	current_characters.enemies = enemies
	current_characters.fleeable = fleeable
	
	for npc in $NPC.get_children():
		if npc.to_be_disabled:
			npc.hide()
	
	global.store_main(self)
	get_tree().change_scene_to_file("res://scenes/battle.tscn")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		emit_signal("done_fading_in")
	elif anim_name == "fade_out":
		emit_signal("done_fading_out")
