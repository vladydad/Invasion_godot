extends Area2D

func _ready() -> void:
	print("one explosion")
	$AnimatedSprite2D.play("default")
	await get_tree().create_timer(0.9).timeout
	$AnimatedSprite2D.stop()
	queue_free()
