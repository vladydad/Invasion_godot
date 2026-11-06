
extends CharacterBody2D

const SPEED = 30.0

var direction = 1
var is_roaming = true
var is_chatting = false

func _ready():
	randomize()
	$Timer.wait_time = randf_range(1.0, 3.0)
	$Timer.start()

	# Останавливаем анимацию
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.frame = 0

func _physics_process(delta):

	if is_roaming and not is_chatting:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	velocity.y = 0

	move_and_slide()

	# Разворот картинки
	$AnimatedSprite2D.flip_h = direction < 0


func _on_timer_timeout():

	# Случайное направление
	direction = [1, -1].pick_random()

	# Следующая смена направления
	$Timer.wait_time = randf_range(1.0, 3.0)
	$Timer.start()


func _on_area_2d_body_entered(body):

	if body.is_in_group("player"):
		is_chatting = true


func _on_area_2d_body_exited(body):

	if body.is_in_group("player"):
		is_chatting = false
