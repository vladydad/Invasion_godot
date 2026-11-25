extends Area2D

var speed = 700
var direction = Vector2.UP

func _ready():
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)


func _physics_process(delta):
	global_position += direction * speed * delta

func _on_area_entered(area):
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("NPC"):
		body.die()
	queue_free()	
