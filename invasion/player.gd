extends CharacterBody2D

var speed = 200
var health = 100

func _physics_process(delta: float) -> void:
	var move_direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		move_direction.x = 1
	elif Input.is_action_pressed("ui_left"):
		move_direction.x = -1
	if Input.is_action_pressed("ui_down"):
		move_direction.y = 1
	elif Input.is_action_pressed("ui_up"):
		move_direction.y = -1

	velocity = move_direction * speed
	move_and_slide()

func change_sprite():
	var texture = load('res://pistol-pickup.png')
	$Sprite2D.texture = texture

@export var bullet_scene: PackedScene

func _process(delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("Shoot"):
		shoot()

func shoot():
	var bullet = bullet_scene.instantiate()

	var direction = (
		get_global_mouse_position() - $goon.global_position
	).normalized()

	get_tree().current_scene.add_child(bullet)

	bullet.global_position = $goon.global_position
	bullet.direction = direction
