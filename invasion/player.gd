extends CharacterBody2D

var weapon = "arms"
var speed = 280 
var health = 50
var ammo = 0
var fast = false
var canShoot = true
var stabbing = false
var m4silencer = false
var reloading = false

@export var bullet_scene: PackedScene

@export var bazooka_scene: PackedScene	

@onready var health_bar = $"../HealthBar"

@onready var ammo_label = $"../CanvasLayer/AmmoLabel"

func highspeed():
	fast = true
	$"../CanvasLayer2/AnimatedSprite2D".visible = true
	$"../CanvasLayer2/AnimatedSprite2D".play("default")
	speed = 500
	await get_tree().create_timer(15).timeout
	speed = 200
	$AnimatedSprite2D.speed_scale = 2
	fast = false
	$"../CanvasLayer2/AnimatedSprite2D".stop()
	$"../CanvasLayer2/AnimatedSprite2D".visible = false		

func maxhealth():
	health=100

func pickup_weapon(picked):
	weapon = picked
	if weapon == "pistol":
		ammo = 10
	elif weapon == "ar":
		ammo = 30
		$"../CanvasLayer/Tips1".visible = true
		await get_tree().create_timer(0.3).timeout
		$"../CanvasLayer/Tips1".visible = false
		await get_tree().create_timer(0.3).timeout
		$"../CanvasLayer/Tips1".visible = true
		await get_tree().create_timer(0.3).timeout
		$"../CanvasLayer/Tips1".visible = false
		await get_tree().create_timer(0.3).timeout
		$"../CanvasLayer/Tips1".visible = true
		await get_tree().create_timer(3).timeout
		$"../CanvasLayer/Tips1".visible = false
	elif weapon == "bazooka":
		ammo = 3

func _physics_process(delta: float) -> void:
	
	if health<40:
		$"../CanvasLayer2/Bloodoverlay".visibility = true
		$"../CanvasLayer2/Bloodoverlay".play("default")
	
	if Input.is_action_pressed("Reload"):
		reload()

	if velocity.length() > 0 and $WalkingSound.playing == false:
		$WalkingSound.play()
	else:
		$WalkingSound.stop()
		
	if velocity.length() > 0:
		if weapon == "arms":
			$AnimatedSprite2D.play("walk")
		elif weapon == "pistol":
			$AnimatedSprite2D.play("pistol")
		elif weapon == "bazooka":
			$AnimatedSprite2D.play("rpg")
		elif weapon == "knife" and stabbing == true:
			$AnimatedSprite2D.play("walkswing")
		elif weapon == "knife" and stabbing == false:
			$AnimatedSprite2D.play("shank")
		elif weapon == "ar":
			$AnimatedSprite2D.play("m4a1")
		
	elif stabbing == true:
		$AnimatedSprite2D.play("swing")
	else:
		$AnimatedSprite2D.stop()


func reload():	
	reloading = true
	canShoot = false
	$ReloadSound.play()
	ammo_label.text = str("...")
	await get_tree().create_timer(2).timeout
	if weapon == "pistol":
		ammo = 10
	elif weapon == "ar":
		ammo = 30
	elif weapon == "bazooka":
		ammo = 3
	canShoot = true
	ammo_label.text = str(ammo)
	reloading = false


func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	if weapon=="bazooka" and fast==false:
		speed =180
	elif weapon=="knife" and fast==false:
		speed = 280
	elif weapon=="pistol" and fast==false:
		speed=280
	
	if Input.is_action_just_pressed("Silencer"):
		if m4silencer == false:
			m4silencer = true
		else:
			m4silencer = false
		
	
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


	if Input.is_action_just_pressed("Shoot") and canShoot:
		if weapon == "pistol":
			shootPistol()
		elif weapon == "bazooka":
			shootBazooka()
		elif weapon == "knife":
			swingKnife()
	if !reloading:
		ammo_label.text = str(ammo)
	health_bar.value = health
		
	if Input.is_action_pressed("Shoot") and canShoot:
		if weapon == "ar":
			shootm4()
	
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
		
		canShoot = false
		
		var direction = (
			get_global_mouse_position() - $goon.global_position
		).normalized()

		get_tree().current_scene.add_child(bullet)

		bullet.global_position = $goon.global_position
		bullet.direction = direction
		
		ammo = ammo -1
		
		if m4silencer == false:
			$RifleSound.play()
		else:
			$SilencerSound.play()
		
		
		await get_tree().create_timer(0.1).timeout
		canShoot = true

func shootBazooka():
	if ammo > 0:
		$RPGSound.play()
		var rocket = bazooka_scene.instantiate()

		canShoot = false

		var direction = (
			get_global_mouse_position() - $zabooka.global_position
		).normalized()

		get_tree().current_scene.add_child(rocket)

		rocket.global_position = $zabooka.global_position
		rocket.direction = direction
		
		ammo = ammo -1
		
		await get_tree().create_timer(1).timeout
		canShoot = true
		

func swingKnife():
	stabbing = true
	canShoot = false
	$KnifeSound.play()
	$AnimatedSprite2D.play("swing")
	if velocity.length() > 0:
		await get_tree().create_timer(0.6).timeout
		stabbing = false
		canShoot = true
	else:
		await get_tree().create_timer(0.4).timeout
		stabbing = false
		canShoot = true
	
