extends Panel

@onready var text_box = get_node("MarginContainer/TextBox")
@onready var text_box_label = text_box.get_node("MarginContainer/Label")

var skipping = false

signal text_done_displaying
signal textbox_closed

func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if text_box_label.visible_characters >= text_box_label.text.length() + 1:
			emit_signal("textbox_closed")
			text_box_label.visible_characters = 0
			hide()
	elif Input.is_action_just_pressed("skip_textbox"):
		skipping = true

func show_text(text):
	show()
	skipping = false
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
	if skipping:
		skipping = false
		text_box_label.visible_characters = 999
		emit_signal("text_done_displaying")
	text_box_label.visible_characters += 1
	if text_box_label.visible_characters == text_box_label.text.length() + 1:
		emit_signal("text_done_displaying")
