extends Area2D

var speed = 700
var direction = Vector2.UP

func _physics_process(delta):
	global_position += direction * speed * delta

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	queue_free()
