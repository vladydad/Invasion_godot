extends CharacterBody2D

var weapon = "arms"
var speed = 280 
var health = 50
var ammo = 0

@onready var health_bar = $"../HealthBar"

#@onready var ammo_label = $"../CanvasLayer/AmmoLabel"

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
	
	if Input.is_action_pressed("Reload"):
		reload()

	if velocity.length() > 0:
		if weapon == "arms":
			$AnimatedSprite2D.play("walk")
		elif weapon == "pistol":
			$AnimatedSprite2D.play("pistol")
		elif weapon == "bazooka":
			$AnimatedSprite2D.play("rpg")
		elif weapon == "knife":
			$AnimatedSprite2D.play("shank")
		elif weapon == "ar":
			$AnimatedSprite2D.play("m4a1")
	else:
		$AnimatedSprite2D.stop()

@export var bullet_scene: PackedScene

@export var bazooka_scene: PackedScene	

func reload():
	$ReloadSound.play()
	await get_tree().create_timer(4).timeout
	if weapon == "pistol":
		ammo = 10
	elif weapon == "ar":
		ammo = 30
	elif weapon == "bazooka":
		ammo = 3

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	var move_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("walkright"):
		move_direction.x = 1
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("walkleft"):
		move_direction.x = -1
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("walkdown"):
		move_direction.y = 1
	elif Input.is_action_pressed("ui_up") or Input.is_action_pressed("walkup"):
		move_direction.y = -1
	velocity = move_direction * speed
	move_and_slide()


	if Input.is_action_just_pressed("Shoot"):
		if weapon == "pistol":
			shootPistol()
		elif weapon == "ar":
			shootm4()
		elif weapon == "bazooka":
			shootBazooka()
		elif weapon == "knife":
			swingKnife()
			$AnimatedSprite2D.play("swing")
	elif ammo == 0:
		#ammo_label.text = "Lader..."
		reload()
	#ammo_label.text = str(ammo)
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

func swingKnife():
	$KnifeSound.play()
	
