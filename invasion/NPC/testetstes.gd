
extends CharacterBody2D

var speed = 200

func _physics_process(delta):
	var move_direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		move_direction.x = 1
	elif Input.is_action_pressed("ui_left"):
		move_direction.x = -1

	if Input.is_action_pressed("ui_down"):
		move_direction.y = 1
	elif Input.is_action_pressed("ui_up"):
		move_direction.y = -1

	velocity = move_direction * speed
	move_and_slide()

func _process(delta):
	if not Input.is_action_just_pressed("ui_accept"):
		return

	var nearest_npc = null
	var nearest_distance = 70.0

	for npc in get_tree().get_nodes_in_group("npcs"):
		if npc.dead:
			continue

		var distance = global_position.distance_to(npc.global_position)

		if distance < nearest_distance:
			nearest_distance = distance
			nearest_npc = npc

	if nearest_npc != null:
		nearest_npc.die()
