extends Resource

@export var name: String = "Player"
@export var texture: Texture = null
@export var sprite: String = "res://scenes/ninja_1_animation.tscn"
@export var flip_h = false

@export var level: int = 1
@export var xp: int = 0
@export var max_hp: int = 12
@export var hp: int = 12
@export var max_mana: int = 25
@export var mana: int = 25
@export var damage: int = 3
@export var defense: int = 0

@export var base_hp: int = 12
@export var base_mana: int = 25
@export var level_curve: Dictionary = { # a(x - 1)^1.3 + b = xp required for next level
	"a": 1,
	"b": 5
}

@export var skills: Array = []
