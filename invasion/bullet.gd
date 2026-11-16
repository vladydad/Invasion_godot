
extends Area2D

var speed = 700
var direction = Vector2.UP

func _ready():
	body_entered.connect(_on_body_entered)


func _physics_process(delta):
	global_position += direction * speed * delta


func _on_body_entered(body):
	print("ПУЛЯ ПОПАЛА!")

	if body.is_in_group("NPC"):
		print("ЭТО NPC!")
		body.die()
		queue_free()
