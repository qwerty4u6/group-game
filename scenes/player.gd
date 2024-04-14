extends Area2D

var anim

var velocity

func _ready():
	anim = $Ninja1Animation

func _process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	position += velocity.normalized() * 300 * delta
	
	if velocity.x < 0:
		anim.flip_h = true
	if velocity.x > 0:
		anim.flip_h = false
	if velocity == Vector2.ZERO:
		anim.play("idle")
	else:
		anim.play("running")
