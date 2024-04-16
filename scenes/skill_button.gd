extends Area2D

@onready var action_box = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()

var slot = 0
var skill
var can_select = false

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
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var overlapping = get_overlapping_areas()
		for area in overlapping:
			if area.is_in_group("mouse_area"):
				action_box.prepare_skill(slot, action_box.get_parent().selected_display())

func darken():
	$Darken.show()
	can_select = false

func lighten():
	$Darken.hide()
	can_select = true
