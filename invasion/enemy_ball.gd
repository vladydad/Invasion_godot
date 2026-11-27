extends Area2D

const HIT_RADIUS = 18.0   

var speed = 300.0
var direction = Vector2.RIGHT
var player = null
var hit = false


func _ready():
	z_index = 100
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(4.0).timeout.connect(queue_free)

	
	for node in get_tree().current_scene.find_children("*", "CharacterBody2D", true, false):
		if node.get("weapon") != null:
			player = node
			break


func _physics_process(delta):
	global_position += direction * speed * delta

	if player != null and is_instance_valid(player) and player.get("is_dead") != true:
		if global_position.distance_to(player.global_position) <= HIT_RADIUS:
			hit_player(player)



func _draw():
	draw_circle(Vector2.ZERO, 6, Color(1, 0.2, 0.2))


func hit_player(target):
	if hit:
		return
	hit = true
	if target.has_method("die"):
		target.die()
	elif target.has_method("take_damage"):
		target.take_damage(9999)
	queue_free()


func _on_body_entered(body):
	if body.get("weapon") != null:
		hit_player(body)
	elif body.has_method("die"):
		return   
	else:
		queue_free()  
