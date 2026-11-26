extends CharacterBody2D

@export var dead_scene: PackedScene        # сюда enemy_2_dead.tscn (если пусто, найдётся сам)
@export var ball_scene: PackedScene        # сюда EnemyBall.tscn (если пусто, найдётся сам)

@export var speed: float = 50.0            # скорость патруля
@export var chase_speed: float = 80.0      # скорость, когда идёт к игроку
@export var sight_range: float = 500.0     # с какого расстояния видит игрока
@export var shoot_range: float = 300.0     # с какого расстояния начинает стрелять
@export var fire_rate: float = 1.2         # пауза между выстрелами (сек)
@export var ball_speed: float = 300.0      # скорость шарика
@export var reaction_time: float = 0.5     # пауза, когда заметил игрока
@export var sprite_faces_right: bool = true  # false, если спрайт смотрит ВЛЕВО

@onready var anim = $AnimatedSprite2D

var direction = Vector2.RIGHT
var stopped = false
var is_dead = false

var player = null
var noticed = false
var reacting = false
var shooting = false
var can_shoot = true
var last_seen_pos = Vector2.ZERO
var has_last_seen = false


func _ready():
	add_to_group("enemy")   # по этой группе пули находят врагов

	if ball_scene == null:
		for path in ["res://EnemyBall.tscn", "res://enemy_ball.tscn", "res://enemyball.tscn"]:
			if ResourceLoader.exists(path):
				ball_scene = load(path)
				break

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

		if reacting:
			velocity = Vector2.ZERO
		elif global_position.distance_to(player.global_position) <= shoot_range:
			velocity = Vector2.ZERO
			try_shoot()
		else:
			velocity = (player.global_position - global_position).normalized() * chase_speed
	else:
		noticed = false
		if has_last_seen and global_position.distance_to(last_seen_pos) > 8.0:
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


# играет анимацию, только если она есть (чтобы не было ошибок)
func play_anim(anim_name: String):
	if anim.sprite_frames != null and anim.sprite_frames.has_animation(anim_name):
		anim.play(anim_name)


func update_animation():
	if shooting:
		return
	if velocity.length() > 1.0:
		play_anim("WALK")
	else:
		play_anim("IDLE")


func try_shoot():
	if not can_shoot or is_dead:
		return
	if ball_scene == null:
		return

	can_shoot = false
	shooting = true
	play_anim("ATTACK")

	var dir = (player.global_position - global_position).normalized()
	var ball = ball_scene.instantiate()
	get_tree().current_scene.add_child(ball)
	ball.global_position = global_position + dir * 20.0
	ball.direction = dir
	ball.speed = ball_speed

	await get_tree().create_timer(0.3).timeout
	shooting = false
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true


func die():
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	remove_from_group("enemy")

	# если поле Dead Scene пустое, ищем сцену трупа сами
	if dead_scene == null:
		for path in ["res://enemy_2_dead.tscn", "res://Enemy_2_dead.tscn", "res://enemy2_dead.tscn"]:
			if ResourceLoader.exists(path):
				dead_scene = load(path)
				break

	if dead_scene != null:
		var corpse = dead_scene.instantiate()
		get_tree().current_scene.add_child(corpse)
		corpse.global_position = global_position
		corpse.global_rotation = global_rotation
		if corpse is CanvasItem:
			corpse.z_index = z_index
		play_corpse_anim(corpse)
		queue_free()
	else:
		play_anim("DEAD")
		for shape in find_children("*", "CollisionShape2D", true, false):
			shape.set_deferred("disabled", true)


# запускает анимацию на трупе (ищет "dead", иначе берёт первую)
func play_corpse_anim(corpse):
	for s in corpse.find_children("*", "AnimatedSprite2D", true, false):
		if s.sprite_frames == null:
			continue
		var names = s.sprite_frames.get_animation_names()
		if names.size() == 0:
			continue
		var chosen = names[0]
		for n in names:
			if str(n).to_lower() == "dead":
				chosen = n
		s.flip_h = anim.flip_h   # труп смотрит в ту же сторону, что и NPC
		s.play(chosen)


# заглушки, чтобы сигналы из сцены не давали ошибок
func _on_detection_area_body_entered(_body):
	pass

func _on_detection_area_body_exited(_body):
	pass

func _on_attack_range_body_entered(_body):
	pass

func _on_attack_range_body_exited(_body):
	pass
