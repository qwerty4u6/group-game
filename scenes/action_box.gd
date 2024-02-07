extends Panel

var text_box
var action_box
var empty_box
var text_box_label

signal text_done_displaying
signal textbox_closed

func _ready():
	text_box = get_node("MarginContainer/TextBox")
	action_box = get_node("MarginContainer/ActionBox")
	empty_box = get_node("MarginContainer/EmptyBox")
	text_box_label = text_box.get_node("MarginContainer/Label")

func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if text_box_label.visible_characters >= text_box_label.text.length() + 1:
			text_box.hide()
			action_box.show()
			emit_signal("textbox_closed")

func to_textbox():
	text_box.show()
	action_box.hide()
	empty_box.hide()

func to_action_box():
	text_box.hide()
	action_box.show()
	empty_box.hide()

func to_empty_box():
	text_box.hide()
	action_box.hite()
	empty_box.show()

func show_text(text):
	to_textbox()
	text_box.get_node("NextLabel").hide()
	
	text_box_label.visible_characters = 0
	text_box_label.get_node("Timer").start()
	text_box_label.text = text
	
	await text_done_displaying
	text_box.get_node("NextLabel").show()
	$AnimationPlayer.play("next arrow")

func _on_timer_timeout():
	text_box_label.visible_characters += 1
	if text_box_label.visible_characters == text_box_label.text.length() + 1:
		emit_signal("text_done_displaying")
