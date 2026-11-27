extends Area2D

const HIT_RADIUS = 22.0   

var speed = 700
var direction = Vector2.UP


func _ready():
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(3.0).timeout.connect(queue_free)


func _physics_process(delta):
	global_position += direction * speed * delta

	for node in get_tree().current_scene.find_children("*", "CharacterBody2D", true, false):
		if node.get("weapon") != null:
			continue   
		if node.get("is_dead") == true:
			continue   
		if node.has_method("die") and global_position.distance_to(node.global_position) <= HIT_RADIUS:
			node.die()
			queue_free()
			return


func _on_body_entered(body):
	if body.get("weapon") != null:
		return   
	if body.get("is_dead") == true:
		return
	if body.has_method("die"):
		body.die()
	queue_free()
