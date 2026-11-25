extends Area2D

@export var explode_scene: PackedScene

const BLAST_RADIUS = 120.0   # радиус взрыва в пикселях

var speed = 700
var direction = Vector2.UP
var exploded = false

func _ready():
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta):
	if exploded:
		return
	global_position += direction * speed * delta
	rotation = direction.angle()
	$AnimatedSprite2D.play("Fly")


func _on_area_entered(area):
	if area.name == "DetectionArea" or area.name == "AttackRange":
		return
	explode()


func _on_body_entered(body):
	if body.get("weapon") != null:
		return
	explode()


func explode():
	if exploded:
		return
	exploded = true
	speed = 0
	$Explosion.play()

	var explosion = explode_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = $AnimatedSprite2D.global_position

	kill_in_radius(explosion.global_position)
	queue_free()


# убиваем всех врагов в радиусе взрыва
func kill_in_radius(center):
	for node in get_tree().current_scene.find_children("*", "CharacterBody2D", true, false):
		if node.get("weapon") != null:
			continue   # это игрок
		var dist = center.distance_to(node.global_position)
		if dist <= BLAST_RADIUS and node.has_method("die"):
			node.die()











#extends Area2D

#@export var explode_scene: PackedScene

#var speed = 700
#var direction = Vector2.UP
#var exploded = false

#func _ready():
	#body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

#func _physics_process(delta):
	#if exploded:
		#return
	#global_position += direction * speed * delta
	#rotation = direction.angle()
	#$AnimatedSprite2D.play("Fly")


#func _on_area_entered(area):
	#speed = 0
	#$Explosion.play()
	#var explosion = explode_scene.instantiate()
	#get_tree().current_scene.add_child(explosion)
	#explosion.global_position = $AnimatedSprite2D.global_position
	#queue_free()	

#func _on_body_entered(body):
	#speed = 0
	#$Explosion.play()
	#var explosion = explode_scene.instantiate()
	#get_tree().current_scene.add_child(explosion)
	#explosion.global_position = $AnimatedSprite2D.global_position
	##if body.has_method("die"):
		#body.die()
	
