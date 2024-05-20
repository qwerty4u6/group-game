extends Node

var stored_main
var stored_team
var should_heal = false

func store_main(main_state):
	stored_main = PackedScene.new()
	stored_main.pack(main_state)

func get_main():
	return stored_main

func store_team(team_state):
	stored_team = []
	for member in team_state:
		var new = PackedScene.new()
		new.pack(member)
		stored_team.push_back(new)

func get_team():
	return stored_team
