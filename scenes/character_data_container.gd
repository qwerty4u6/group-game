extends Node

@export var name_text: String = "Player"
@export var texture: Texture = null
@export var level: int = 1
@export var max_hp: int = 12
@export var hp: int = 12
@export var max_mana: int = 25
@export var mana: int = 25
@export var damage: int = 3

@export var type: String = "Enemy"

@export var skills: Array = []

func init(res):
	name_text = res.name
	texture = res.texture
	level = res.level
	max_hp = res.max_hp
	hp = res.hp
	max_mana = res.max_mana
	mana = res.mana
	damage = res.damage
	
	skills = res.skills
