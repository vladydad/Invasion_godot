extends CharacterBody2D

var speed = 50
var direction = Vector2.RIGHT
var stopped = false

var min_x = -50
var max_x = 50
var min_y = -50
var max_y = 50

@onready var anim = $AnimatedSprite2D

func _ready():
	random_walk()

func random_walk():
	while true:
		direction = [
			Vector2.RIGHT,
			Vector2.LEFT,
			Vector2.UP,
			Vector2.DOWN
		].pick_random()

		stopped = false
		await get_tree().create_timer(randf_range(2, 4)).timeout

		stopped = true
		await get_tree().create_timer(randf_range(1, 3)).timeout

func _physics_process(delta):
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
		
