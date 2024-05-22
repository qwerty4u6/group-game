extends Area2D

@onready var action_box = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()

var slot = 0
var skill
var can_select = false
var clickable = false

func init(i, init_skill = {"name": "none", "mana_cost": 99}, mana = 0):
	slot = i
	skill = init_skill
	$NameLabel.text = skill.name
	$CostLabel.text = str(skill.mana_cost)
	if mana < skill.mana_cost:
		darken()
	else:
		lighten()

func _input(event):
	if clickable && Input.is_action_just_pressed("click"):
		var overlapping = get_overlapping_areas()
		for area in overlapping:
			if area.is_in_group("mouse_area"):
				action_box.prepare_skill(slot)

func darken():
	$Darken.show()
	can_select = false

func lighten():
	$Darken.hide()
	can_select = true

func _on_area_entered(area):
	if area.is_in_group("mouse_area") && can_select:
		$NameLabel.text = skill.name + " <"

func _on_area_exited(area):
	if area.is_in_group("mouse_area") && skill != null:
		$NameLabel.text = skill.name
