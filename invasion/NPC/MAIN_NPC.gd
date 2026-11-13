
extends CharacterBody2D

var speed = 50
var direction = Vector2.RIGHT
var stopped = false
var dead = false

var min_x = -50
var max_x = 50
var min_y = -50
var max_y = 50

@onready var anim = $AnimatedSprite2D


func _ready():
	anim.animation_finished.connect(_on_animation_finished)
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
		direction = Vector2.UP
	if position.y < min_y:
		direction = Vector2.DOWN
		
func die():
	if dead:
		return

	dead = true
	velocity = Vector2.ZERO
	anim.play("DEAD")

func _on_animation_finished():
	if anim.animation == "DEAD":
		queue_free()
