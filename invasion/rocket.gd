extends Area2D

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
	if exploded:
		return
	exploded = true
	$Explosion.play()
	$AnimatedSprite2D.play("Explode")
	await get_tree().create_timer(0.9).timeout
	queue_free()

func _on_body_entered(body):
	if exploded:
		return
	exploded= true
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("Explode")
	$Explosion.play()
	if body.has_method("die"):
		body.die()
	
