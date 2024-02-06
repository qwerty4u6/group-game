extends Panel

var text_box
var action_box
var text_box_label

func _ready():
	text_box = get_node("MarginContainer/TextBox")
	text_box_label = text_box.get_node("MarginContainer/Label")
	$AnimationPlayer.play("next arrow")
	
	action_box = get_node("MarginContainer/ActionBox")
	
	text_box.hide()
	action_box.show()

func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		text_box.hide()
		action_box.show()

func show_text(text):
	text_box.show()
	action_box.hide()
	
	text_box_label.visible_characters = 0
	text_box_label.get_node("Timer").start()
	text_box_label.text = text

func _on_timer_timeout():
	text_box_label.visible_characters += 1
