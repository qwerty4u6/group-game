extends CharacterBody2D

@onready var anim = $Ninja1Animation

var interacting_with = null
var can_walk = false
var dist = 0

func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if interacting_with != null && interacting_with.get_node("Interactable").overlaps_body(self):
			interacting_with.interact()

func _process(delta):
	velocity = Vector2.ZERO
	if can_walk:
		var stored_position = position
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
		
		dist += 1
		if stored_position != position:
			battle_check()
	
	if velocity.x < 0:
		anim.flip_h = true
	if velocity.x > 0:
		anim.flip_h = false
	if velocity != Vector2.ZERO:
		anim.play("running")
	else:
		anim.play("idle")

func battle_check():
	var areas = get_parent().get_node("RandomEnemyEncounters").get_children()
	for area in areas:
		var bodies = area.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("player"):
				area.calc(dist)
				return
