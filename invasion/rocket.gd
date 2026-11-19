extends Area2D

var speed = 700
var direction = Vector2.UP

func _ready():
	body_entered.connect(_on_body_entered)


func _physics_process(delta):
	global_position += direction * speed * delta
	rotation = direction.angle()
	$AnimatedSprite2D.play("Fly")

func _on_body_entered(body):
	$AnimatedSprite2D.play("Explode")
	print("boom")
	if body.has_method("die"):
		body.die()

func _on_area_entered():
	$AnimatedSprite2D.play("Explode")

	queue_free()
