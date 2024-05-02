extends Area2D

@onready var action_box = get_parent().get_parent().get_parent().get_parent().get_parent()

var clickable = false

func _input(event):
	if clickable && Input.is_action_just_pressed("click"):
		var overlapping = get_overlapping_areas()
		for area in overlapping:
			if area.is_in_group("mouse_area"):
				action_box.frames_after_back = 0
				action_box.to_action_box(action_box.get_parent().current_character)

func _on_area_entered(area):
	if area.is_in_group("mouse_area"):
		$NameLabel.text = "Back <"

func _on_area_exited(area):
	if area.is_in_group("mouse_area"):
		$NameLabel.text = "Back"
