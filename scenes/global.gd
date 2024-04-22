extends Node

var stored_main

func store_main(main_state):
	stored_main = PackedScene.new()
	stored_main.pack(main_state)
	print(stored_main)

func get_main():
	return stored_main
