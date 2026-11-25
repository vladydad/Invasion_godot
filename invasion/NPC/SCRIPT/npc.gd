extends CharacterBody2D

@export var speed: float = 50.0
@export var chase_speed: float = 90.0
@export var attack_damage_cooldown: float = 1.0
@export var reaction_time: float = 0.4      # hvor lenge NPC-en stopper og ser på spilleren før den løper
@export var sprite_faces_right: bool = true  # sett til false hvis sprite-bildet ser mot VENSTRE som standard

@onready var anim = $AnimatedSprite2D

var direction = Vector2.RIGHT
var stopped = false
var is_dead = false

var target = null
var player_in_range = false
var can_attack = true
var reacting = false
var attacking = false


func _ready():
	random_walk()


func random_walk():
	while not is_dead:
		if target != null:
			await get_tree().create_timer(0.5).timeout
			continue

		direction = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN].pick_random()
		stopped = false
		await get_tree().create_timer(2).timeout

		stopped = true
		await get_tree().create_timer(2).timeout


func _physics_process(_delta):
	if is_dead:
		return

	if target != null and is_instance_valid(target):
		face_towards(target.global_position.x - global_position.x)

		if reacting:
			velocity = Vector2.ZERO          # ser på spilleren
		elif player_in_range:
			velocity = Vector2.ZERO
			try_attack()
		else:
			var dir = (target.global_position - global_position).normalized()
			velocity = dir * chase_speed
	elif stopped:
		velocity = Vector2.ZERO
	else:
		velocity = direction * speed
		face_towards(direction.x)

	move_and_slide()
	update_animation()


# Snu sprite mot venstre/høyre
func face_towards(dx: float):
	if abs(dx) < 1.0:
		return
	var looking_right = dx > 0
	anim.flip_h = (looking_right != sprite_faces_right)


func update_animation():
	if attacking:
		return
	if velocity.length() > 1.0:
		anim.play("WALK")
	else:
		anim.play("IDLE")


func try_attack():
	if not can_attack:
		return
	if target.is_dead:
		return

	can_attack = false
	attacking = true
	anim.play("ATTACK")
	target.die()

	await get_tree().create_timer(0.6).timeout
	attacking = false

	await get_tree().create_timer(attack_damage_cooldown).timeout
	can_attack = true


func die():
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	target = null
	anim.play("DEAD")


# DetectionArea -> body_entered
func _on_detection_area_body_entered(body):
	if is_dead or not body.is_in_group("player"):
		return
	if target == null:
		target = body
		reacting = true
		await get_tree().create_timer(reaction_time).timeout
		reacting = false

# DetectionArea -> body_exited
func _on_detection_area_body_exited(body):
	if body == target:
		target = null
		reacting = false

# AttackRange -> body_entered
func _on_attack_range_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

# AttackRange -> body_exited
func _on_attack_range_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
