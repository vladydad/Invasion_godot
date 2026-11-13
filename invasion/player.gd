extends CharacterBody2D

var weapon = "pistol"
var speed = 200
var health = 50
var ammo = 10

@onready var health_bar = $"../HealthBar"

@onready var ammo_label = $"../CanvasLayer/AmmoLabel"

func highspeed():
	speed = 500
	await get_tree().create_timer(15).timeout
	speed = 200
	$AnimatedSprite2D.speed_scale = 2

func maxhealth():
	health=100

func pickup_weapon(texture):
	$Sprite2D.texture = texture
	weapon = "ar"
	ammo = 30

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
	if Input.is_action_pressed("Reload"):
		reload()

	velocity = move_direction * speed
	move_and_slide()
	if velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.stop()

func change_sprite():
	var texture = load('res://pistol-pickup.png')
	$Sprite2D.texture = texture

@export var bullet_scene: PackedScene

func reload():
	await get_tree().create_timer(4).timeout
	if weapon == "pistol":
		ammo = 10
	elif weapon == "ar":
		ammo = 30

func _process(delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("Shoot") and ammo>0:
		if weapon == "pistol":
			shootPistol()
		elif weapon == "ar":
			shootm4()
		ammo = ammo - 1
	elif ammo == 0:
		ammo_label.text = "Lader..."
		reload()
	ammo_label.text = str(ammo)
	health_bar.value = health
		
func shootPistol():
	var bullet = bullet_scene.instantiate()

	var direction = (
		get_global_mouse_position() - $goon.global_position
	).normalized()

	get_tree().current_scene.add_child(bullet)

	bullet.global_position = $goon.global_position
	bullet.direction = direction
	
	$ShootSound.play()

func shootm4():
	var bullet = bullet_scene.instantiate()

	var direction = (
		get_global_mouse_position() - $goon.global_position
	).normalized()

	get_tree().current_scene.add_child(bullet)

	bullet.global_position = $goon.global_position
	bullet.direction = direction
	
	$RifleSound.play()
