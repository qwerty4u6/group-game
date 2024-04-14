extends CharacterBody2D

var anim

func _ready():
	anim = $Ninja1Animation

func _process(delta):
	#if not is_on_floor():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	velocity = velocity.normalized() * 300
	move_and_slide()
	
	if velocity.x < 0:
		anim.flip_h = true
	if velocity.x > 0:
		anim.flip_h = false
	if velocity == Vector2.ZERO:
		anim.play("idle")
	else:
		anim.play("running")
