extends StaticBody2D

@onready var main = get_parent()
@onready var player = main.get_node("Player")
@onready var text_box = main.get_node("CanvasLayer/TextBox")

func _ready():
	$Ninja2Animation.play("idle")

func _on_interactable_body_entered(body):
	if body == player:
		player.interacting_with = self

func interact():
	player.interacting_with = null
	player.can_walk = false
	
	text_box.show_text("Lets fight!")
	await text_box.textbox_closed
	
	main.start_battle(main.team, [
		"res://resources/enemy characters/fisherman.tres",
		"res://resources/enemy characters/sushi chef.tres"
	], "A fisherman and sushi chef appear!")
