extends Panel

var res
@onready var battle = get_parent()
@onready var hp_bar = $HealthBar
@onready var hp_label = hp_bar.get_node("Label")
@onready var mana_bar = $ManaBar
@onready var mana_label = mana_bar.get_node("Label")
@onready var death_thingy = get_node("MarginContainer/DeathThingy")

var hovering = false
var dead = false

signal mouse_exit
signal selected

func _ready():
	$SelectLabel.hide()
	$SelectLabel.size = Vector2(210, 132) # why does it keep resizing should i have to do this
	$SelectLabel2.hide()
	$SelectLabel2.size = Vector2(210, 132)
	death_thingy.hide()

func init(member):
	res = member
	get_node("NameLabel").text = res.name_text
	get_node("LevelLabel").text = "lvl. " + str(res.level)
	get_node("TextureRect").texture = res.texture
	set_max_hp(res.max_hp)
	set_hp(res.hp)
	set_max_mana(res.max_mana)
	set_mana(res.mana)

func set_max_hp(hp):
	hp_bar.max_value = hp

func set_hp(hp):
	hp_bar.value = hp
	hp_label.text = str(hp)

func set_max_mana(mana):
	mana_bar.max_value = mana

func set_mana(mana):
	mana_bar.value = mana
	mana_label.text = str(mana)

func damage(amt):
	res.hp -= amt
	set_hp(res.hp)
	if res.hp <= 0:
		kill()

func kill():
	dead = true
	set_hp(0)
	set_mana(0)
	death_thingy.show()
	hp_label.text = ""
	mana_label.text = ""
	battle.characters.erase(res)

func _on_area_2d_area_entered(area):
	if area.is_in_group("mouse_area"):
		start_hover()

func _on_area_2d_area_exited(area):
	if area.is_in_group("mouse_area"):
		stop_hover()

func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if battle.selecting && battle.selected_display() == self && battle.select_target == res.type && !dead:
			var action_box = battle.get_node("ActionBox")
			action_box.target = self
			action_box.emit_signal("selected")

func start_hover():
	hovering = true
	if battle.selecting && battle.select_target == res.type && !dead:
		$AnimationPlayer.play("selection")
		$SelectLabel.show()
		$SelectLabel2.show()

func stop_hover():
	hovering = false
	$SelectLabel.hide()
	$SelectLabel2.hide()
