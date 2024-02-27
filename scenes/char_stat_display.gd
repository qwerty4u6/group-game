extends Panel

var res
@onready var battle = get_parent()
@onready var hp_bar = $HealthBar
@onready var hp_label = hp_bar.get_node("Label")
@onready var mana_bar = $ManaBar
@onready var mana_label = mana_bar.get_node("Label")
@onready var mouse_area = $"/root/Battle/MouseArea"

signal mouse_exit

func _ready():
	$SelectLabel.hide()
	$SelectLabel.size = Vector2(210, 132) # why does it keep resizing should i have to do this
	$SelectLabel2.hide()
	$SelectLabel2.size = Vector2(210, 132)

func init(member):
	res = member
	get_node("NameLabel").text = res.name
	get_node("LevelLabel").text = "lvl. " + str(res.level)
	get_node("TextureRect").texture = res.texture
	set_max_hp(res.max_hp)
	set_hp(res.hp)
	set_max_mana(res.max_mana)
	set_mana(res.mana)
	print(res)

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

func _on_area_2d_area_entered(area):
	if area == mouse_area:
		start_hover()
		battle.selected_display = res
		await mouse_exit
		stop_hover()
		battle.selected_display = null

func _on_area_2d_area_exited(area):
	if area == mouse_area:
		emit_signal("mouse_exit")

func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		print("dgkjdgj") #!!!!!!!!!!!!!!!!!

func start_hover():
	if battle.selecting == false:
		return
	$AnimationPlayer.play("selection")
	$SelectLabel.show()
	$SelectLabel2.show()

func stop_hover():
	$SelectLabel.hide()
	$SelectLabel2.hide()
