extends Area2D

var skill
var can_select = false

func init(init_skill = {"name": "none", "mana_cost": 999}, mana = 0):
	skill = init_skill
	$NameLabel.text = skill.name
	$CostLabel.text = str(skill.mana_cost)
	if mana < skill.mana_cost:
		darken()
	else:
		lighten()

func _on_area_entered(area):
	if area.is_in_group("mouse_area"):
		pass

func _on_area_exited(area):
	if area.is_in_group("mouse_area"):
		pass


func darken():
	$Darken.show()
	can_select = false

func lighten():
	$Darken.hide()
	can_select = true
