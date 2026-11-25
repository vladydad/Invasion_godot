extends CharacterBody2D

@export var speed: float = 50.0            
@export var chase_speed: float = 90.0      
@export var sight_range: float = 350.0    
@export var attack_range: float = 40.0     
@export var attack_cooldown: float = 1.0
@export var reaction_time: float = 0.4     
@export var sprite_faces_right: bool = true  

@onready var anim = $AnimatedSprite2D

var direction = Vector2.RIGHT
var stopped = false
var is_dead = false

var player = null
var noticed = false
var reacting = false
var attacking = false
var can_attack = true
var last_seen_pos = Vector2.ZERO
var has_last_seen = false


func _ready():
	random_walk()


func random_walk():
	while not is_dead:
		direction = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN].pick_random()
		stopped = false
		await get_tree().create_timer(2).timeout
		stopped = true
		await get_tree().create_timer(2).timeout


func _physics_process(_delta):
	if is_dead:
		return

	if player == null or not is_instance_valid(player):
		player = find_player()

	if can_see_player():
		last_seen_pos = player.global_position
		has_last_seen = true
		face(player.global_position.x - global_position.x)

		if not noticed:
			notice()

		if reacting or attacking:
			velocity = Vector2.ZERO
		elif global_position.distance_to(player.global_position) <= attack_range:
			velocity = Vector2.ZERO
			try_attack()
		else:
			velocity = (player.global_position - global_position).normalized() * chase_speed
	else:
		noticed = false
		if has_last_seen and global_position.distance_to(last_seen_pos) > 8.0:
			# потерял игрока -> идёт к месту, где видел его в последний раз
			face(last_seen_pos.x - global_position.x)
			velocity = (last_seen_pos - global_position).normalized() * chase_speed
		else:
			has_last_seen = false
			if stopped:
				velocity = Vector2.ZERO
			else:
				velocity = direction * speed
				face(direction.x)

	move_and_slide()
	update_animation()


# игрок = персонаж, у которого есть переменная weapon
func find_player():
	for node in get_tree().current_scene.find_children("*", "CharacterBody2D", true, false):
		if node.get("weapon") != null:
			return node
	return null


# видит ли NPC игрока (близко и нет стены между ними)
func can_see_player() -> bool:
	if player == null or not is_instance_valid(player):
		return false
	if player.get("is_dead") == true:
		return false
	if global_position.distance_to(player.global_position) > sight_range:
		return false

	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	query.exclude = [get_rid()]
	var result = get_world_2d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		return false
	# попали в игрока (или в другого NPC) -> стены нет
	return result.collider == player or result.collider.has_method("die")


func notice():
	noticed = true
	reacting = true
	await get_tree().create_timer(reaction_time).timeout
	reacting = false


func face(dx: float):
	if abs(dx) < 1.0:
		return
	anim.flip_h = ((dx > 0) != sprite_faces_right)


func update_animation():
	if attacking:
		return
	if velocity.length() > 1.0:
		anim.play("WALK")
	else:
		anim.play("IDLE")


func try_attack():
	if not can_attack or is_dead:
		return
	can_attack = false
	attacking = true
	anim.play("ATTACK")

	if player.has_method("die"):
		player.die()
	elif player.has_method("take_damage"):
		player.take_damage(9999)

	await get_tree().create_timer(0.6).timeout
	attacking = false
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true


func die():
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	anim.play("DEAD")
	for shape in find_children("*", "CollisionShape2D", true, false):
		shape.set_deferred("disabled", true)



func _on_detection_area_body_entered(_body):
	pass

func _on_detection_area_body_exited(_body):
	pass

func _on_attack_range_body_entered(_body):
	pass

func _on_attack_range_body_exited(_body):
	pass
