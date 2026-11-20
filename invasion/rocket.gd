extends Area2D

@export var explode_scene: PackedScene

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
	speed = 0
	$Explosion.play()
	var explosion = explode_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = $AnimatedSprite2D.global_position
	queue_free()	

func _on_body_entered(body):
	speed = 0
	$Explosion.play()
	var explosion = explode_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = $AnimatedSprite2D.global_position
	queue_free()	
	if body.has_method("die"):
		body.die()
	
