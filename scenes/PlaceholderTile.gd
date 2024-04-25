extends Sprite2D

var s = 0.01
var v = 0.05
var tick = 0.0

func _process(delta):
	s += v
	v *= 0.95
	var r = sin(tick / 40)
	var r2 = sin(tick / 50)
	scale = Vector2(r + 5, r + 5) * s / 2
	rotation = r2 / 6
	tick += 1
