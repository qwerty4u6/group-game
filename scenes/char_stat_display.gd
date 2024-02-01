extends Panel

var res

var hp_bar
var hp_label
var mana_bar
var mana_label

func _ready():
	hp_bar = $HealthBar
	hp_label = hp_bar.get_node("Label")
	mana_bar = $ManaBar
	mana_label = mana_bar.get_node("Label")

func init(member):
	res = member
	get_node("NameLabel").text = res.name
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
