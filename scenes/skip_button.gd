extends Area2D

@onready var action_box = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()

var clickable = false

func _input(event):
	if clickable && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var overlapping = get_overlapping_areas()
		for area in overlapping:
			if area.is_in_group("mouse_area"):
				print("click!")

func _on_area_entered(area):
	if area.is_in_group("mouse_area"):
		$NameLabel.text = "Skip <"

func _on_area_exited(area):
	if area.is_in_group("mouse_area"):
		$NameLabel.text = "Skip"
