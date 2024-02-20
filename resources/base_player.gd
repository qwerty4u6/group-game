extends Resource

@export var name: String = "Player"
@export var texture: Texture = null

@export var level: int = 1
@export var xp_until_next: float = 5.0
@export var max_hp: int = 12
@export var hp: int = 12
@export var max_mana: int = 25
@export var mana: int = 25
@export var damage: int = 3

@export var base_hp: int = 12
@export var base_mana: int = 25
@export var level_curve: Dictionary = { # a(x - 1)^2 + b = xp required for next level
	"a": 2.6,
	"b": 5
}

@export var skills: Array = [
	{
		"name": "Throwing Stars",
		"unlocked_at": 1,
		"target": "enemy",
		"applies": ["damage", 0, 1]   #  strength, amt of attacks
	}, {
		"name": "Attack 2",
		"unlocked_at": 3,
		"target": "self",
		"applies": ["heal", 0, 1]
	}, {
		"name": "Blah bla",
		"unlocked_at": 7,
		"target": "ally",
		"applies": ["status", "strength", 1]
	}, {
		"name": "dgddf",
		"unlocked_at": 12,
		"target": "enemy",
		"applies": ["splash", -1, 1]
	}
]
