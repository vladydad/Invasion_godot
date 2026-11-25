
extends CharacterBody2D

@export var speed: float = 50.0
@export var chase_speed: float = 90.0
@export var damage: int = 10
@export var attack_damage_cooldown: float = 1.0
@export var reaction_time: float = 0.4
@export var sprite_faces_right: bool = true

var target = null
@onready var anim = $AnimatedSprite2D

var direction = Vector2.RIGHT
var stopped = false
var dead = false
var player_in_range = false
var can_attack = true
var reacting = false
var attacking = false

func _ready():
	anim.animation_finished.connect(_on_animation_finished)
	random_walk()


func random_walk():
	while not dead:
		if target != null:
			await get_tree().create_timer(0.5).timeout
			continue

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


func _physics_process(_delta):
	if dead:
		velocity = Vector2.ZERO
		return

	if target != null and is_instance_valid(target):
		face_towards(target.global_position.x - global_position.x)

		if reacting:
			velocity = Vector2.ZERO
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

	if not is_instance_valid(target):
		return

	if target.get("health") != null and target.health <= 0:
		return

	can_attack = false
	attacking = true
	anim.play("ATTACK")

	if target.has_method("take_damage"):
		target.take_damage(damage)

	await get_tree().create_timer(0.6).timeout
	attacking = false

	await get_tree().create_timer(attack_damage_cooldown).timeout
	can_attack = true


func die():
	if dead:
		return

	dead = true
	velocity = Vector2.ZERO
	anim.play("DEAD")

	dead = true
	velocity = Vector2.ZERO
	target = null
	player_in_range = false
	attacking = false

	for zone_name in ["DetectionArea", "AttackRange"]:
		var zone = get_node_or_null(zone_name)
		if zone:
			zone.set_deferred("monitoring", false)

	anim.play("DEAD")


func _on_animation_finished():
	if anim.animation == "DEAD":
		queue_free()


func _is_player(body) -> bool:
	return body.is_in_group("player") or body.is_in_group("Player")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		die()


func _on_detection_area_body_entered(body):
	if dead or not _is_player(body):
		return

	if target == null:
		target = body
		reacting = true
		await get_tree().create_timer(reaction_time).timeout

		if not dead and is_instance_valid(target):
			reacting = false


func _on_detection_area_body_exited(body):
	if body == target:
		target = null
		reacting = false


func _on_attack_range_body_entered(body):
	if _is_player(body):
		player_in_range = true


func _on_attack_range_body_exited(body):
	if _is_player(body):
		player_in_range = false
