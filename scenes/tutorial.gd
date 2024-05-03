extends StaticBody2D

@onready var main = get_parent().get_parent()
@onready var player = main.get_node("Player")
@onready var text_box = main.get_node("CanvasLayer/TextBox")

var to_be_disabled = false

func _ready():
	$Ninja2Animation.play("idle")
	if !visible:
		$CollisionShape2D.queue_free()
		$Interactable/CollisionShape2D.queue_free()

func _on_interactable_body_entered(body):
	if body == player:
		player.interacting_with = self

func interact():
	player.interacting_with = null
	player.can_walk = false
	
	text_box.show_text("Hey! You know why you were sent here..")
	await text_box.textbox_closed
	await get_tree().create_timer(0.1).timeout
	text_box.show_text("You were trying to stop your families fishing business!")
	await text_box.textbox_closed
	await get_tree().create_timer(0.1).timeout
	text_box.show_text("Just because you want to stop overfishing, doesn't mean I'll let you cause trouble in the fish market as well..")
	await text_box.textbox_closed
	
	to_be_disabled = true
	main.start_battle(main.team, ["The fisherman attacks!", 
		"res://resources/enemy characters/friendly chef.tres"
	])
