extends Area2D

@onready var action_box = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()

var clickable = false
var skippable = false

func _input(event):
	if clickable && Input.is_action_just_pressed("click") && action_box.frames_after_back > 0:
		var overlapping = get_overlapping_areas()
		for area in overlapping:
			if area.is_in_group("mouse_area"):
				flee_attempt()

func flee_attempt():
	if skippable:
		if randi() % 4 == 1:
			action_box.get_parent().good_flee()
		else:
			action_box.get_parent().bad_flee()
	else:
		action_box.show_text("You can't flee from this battle!")
		await action_box.textbox_closed
		action_box.to_action_box(action_box.get_parent().current_character)
	

func _on_area_entered(area):
	if area.is_in_group("mouse_area"):
		$NameLabel.text = "Run <"

func _on_area_exited(area):
	if area.is_in_group("mouse_area"):
		$NameLabel.text = "Run"
