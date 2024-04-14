extends CharacterBody2D

@onready var anim = $Ninja1Animation

var interacting_with = null
var can_walk = false

func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if interacting_with != null && interacting_with.get_node("Interactable").overlaps_body(self):
			interacting_with.interact()

func _process(delta):
	velocity = Vector2.ZERO
	if can_walk:
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
