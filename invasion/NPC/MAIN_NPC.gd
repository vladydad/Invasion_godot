
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
		await get_tree().create_timer(randf_range(2, 4)).timeout

		if dead:
			return

		stopped = true
		await get_tree().create_timer(randf_range(1, 3)).timeout

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

func _process(delta):
	var player = 
	get_tree().get_first_node_in_group("player")

	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)

	if distance < 70:
		print("PLAYER NEAR NPC")

		if Input.is_key_pressed(KEY_ENTER) and not dead:
			print("ENTER PRESSED")
			dead = true
			anim.play("DEAD")

func die():
	dead = true
	anim.play("DEAD")
