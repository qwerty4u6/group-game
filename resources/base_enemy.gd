extends Resource

@export var name: String = "Enemy"
@export var texture: Texture = null
@export var sprite: String = "res://scenes/ninja_1_animation.tscn"

@export var level: int = 1
@export var max_hp: int = 25
@export var hp: int = 25
@export var max_mana: int = 25
@export var mana: int = 25
@export var damage: int = 2

@export var skills: Array = []
@export var skill_order: Array = []
