
extends CharacterBody2D

var speed = 50
var direction = Vector2.RIGHT
var stopped = false
var dead = false
var player_near = false

var min_x = -50
var max_x = 50
var min_y = -50
var max_y = 50

@onready var anim = $AnimatedSprite2D
@onready var area = $Area2D


func _ready():
	random_walk()


func random_walk():
	while true:
		if dead:
			return

		direction = [
			Vector2.RIGHT,
			Vector2.LEFT,
			Vector2.UP,
			Vector2.DOWN
		].pick_random()

		stopped = false
		await get_tree().create_timer(2).timeout

		if dead:
			return

		stopped = true
		await get_tree().create_timer(2).timeout


func _physics_process(delta):
	if dead:
		velocity = Vector2.ZERO
		return

	if stopped:
		velocity = Vector2.ZERO
		anim.play("IDLE")
	else:
		velocity = direction * speed
		anim.play("WALK")

	move_and_slide()

	if position.x > max_x:
		direction = Vector2.LEFT
	if position.x < min_x:
		direction = Vector2.RIGHT
	if position.y > max_y:
		direction = Vector2.DOWN
	if position.y < min_y:
		direction = Vector2.UP


func _process(delta):
	if dead:
		return

	if Input.is_action_just_pressed("interact"):
		if player_near:
			die()
		else:
			print(name, ": PLAYER НЕ РЯДОМ!")


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_near = true
		print(name, ": PLAYER РЯДОМ!")


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_near = false
		print(name, ": PLAYER ВЫШЕЛ!")


func die():
	if dead:
		return

	dead = true
	velocity = Vector2.ZERO

	print(name, ": NPC УМИРАЕТ!")

	anim.play("DEAD")
