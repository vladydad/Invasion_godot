extends Area2D

const HIT_RADIUS = 22.0   # на каком расстоянии от врага пуля убивает

var speed = 700
var direction = Vector2.UP


func _ready():
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(3.0).timeout.connect(queue_free)


func _physics_process(delta):
	global_position += direction * speed * delta

	# убиваем врага, который оказался рядом с пулей
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if is_instance_valid(enemy) and enemy.has_method("die"):
			if global_position.distance_to(enemy.global_position) <= HIT_RADIUS:
				enemy.die()
				queue_free()
				return


func _on_body_entered(body):
	if body.get("weapon") != null:
		return   # это игрок
	if body.has_method("die"):
		body.die()
	queue_free()
