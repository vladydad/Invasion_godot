extends CharacterBody2D

var weapon = "arms"
var speed = 280 
var health = 50
var ammo = 0

@onready var health_bar = $"../HealthBar"

@onready var ammo_label = $"../CanvasLayer/AmmoLabel"

func highspeed():
	speed = 500
	await get_tree().create_timer(15).timeout
	speed = 200
	$AnimatedSprite2D.speed_scale = 2

func maxhealth():
	health=100

func pickup_weapon(picked):
	weapon = picked
	if weapon == "pistol":
		ammo = 10
	elif weapon == "ar":
		ammo = 30
	elif weapon == "bazooka":
		ammo = 3

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

@export var bazooka_scene: PackedScene


func reload():
	await get_tree().create_timer(4).timeout
	if weapon == "pistol":
		ammo = 10
	elif weapon == "ar":
		ammo = 30

func _process(delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("Shoot"):
		if weapon == "pistol":
			shootPistol()
		elif weapon == "ar":
			shootm4()
		elif weapon == "bazooka":
			shootBazooka()
	elif ammo == 0:
		ammo_label.text = "Lader..."
		reload()
	ammo_label.text = str(ammo)
	health_bar.value = health
		
func shootPistol():
	if ammo > 0:
		var bullet = bullet_scene.instantiate()

		var direction = (
			get_global_mouse_position() - $goon.global_position
		).normalized()

		get_tree().current_scene.add_child(bullet)

		bullet.global_position = $goon.global_position
		bullet.direction = direction
		
		ammo = ammo -1
		
		$ShootSound.play()

func shootm4():
	if ammo > 0:
		var bullet = bullet_scene.instantiate()

		var direction = (
			get_global_mouse_position() - $goon.global_position
		).normalized()

		get_tree().current_scene.add_child(bullet)

		bullet.global_position = $goon.global_position
		bullet.direction = direction
		
		ammo = ammo -1
		
		$RifleSound.play()

#func stab():

func shootBazooka():
	if ammo > 0:
		var rocket = bazooka_scene.instantiate()

		var direction = (
			get_global_mouse_position() - $zabooka.global_position
		).normalized()

		get_tree().current_scene.add_child(rocket)

		rocket.global_position = $zabooka.global_position
		rocket.direction = direction
		
		ammo = ammo -1
		
		$RifleSound.play()	
