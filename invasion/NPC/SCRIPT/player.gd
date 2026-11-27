extends CharacterBody2D

@export var speed: float = 400.0

@onready var anim = $AnimatedSprite2D

var is_dead = false
var nearby_npc = null


func _physics_process(_delta):
	if is_dead:
		return

	var direction = Input.get_vector("uileft", "uiright", "uiup", "uidown")
	velocity = direction * speed
	move_and_slide()

	if Input.is_action_just_pressed("attack"):
		if nearby_npc != null and is_instance_valid(nearby_npc):
			nearby_npc.die()


func die():
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	if anim.sprite_frames.has_animation("DEAD"):
		anim.play("DEAD")
	else:
		anim.stop()
		modulate = Color(1, 0.3, 0.3)  


func _on_melee_zone_body_entered(body):
	if body.is_in_group("enemy"):
		nearby_npc = body


func _on_melee_zone_body_exited(body):
	if body == nearby_npc:
		nearby_npc = null
