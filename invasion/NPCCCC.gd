 const speed = 30.0

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

var current_state = MOVE
var dir = Vector2.RIGHT

var is_romaing = true
var is_chatting = false

var player
var player_in_chat_zone = false

func _ready():
	randomize()
	$Timer.start()

func _physics_process(delta):
	if is_romaing and not is_chatting:
		if current_state == MOVE:
			velocity = dir * speed
			move_and_slide()
		else:
			velocity = Vector2.ZERO
			else:
			velocity = Vector2.ZERO

			if current_state == IDLE:
		$AnimatedSprite2D2.play("IDLE")
			elif current_state == NEW_DIR:
		dir = [Vector2.RIGHT, Vector2.LEFT].pick_random()
		current_state = MOVE
			elif current_state == MOVE and not is_chatting:
			$AnimatedSprite2D2.play("TALK")

		func choose(array):
		array.shuffle()
		return array.front()

func _on_timer_timeout():
	current_state = choose([IDLE, NEW_DIR, MOVE])
	$Timer.wait_time = choose([0.5, 1.0, 1.5])
	$Timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_in_chat_zone = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player_in_chat_zone = false
