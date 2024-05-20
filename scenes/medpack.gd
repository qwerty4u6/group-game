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
	
	text_box.show_text("Your party has been restored to full health!")
	await text_box.textbox_closed
	
	player.can_walk = true
