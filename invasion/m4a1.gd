extends Area2D

@export var held_player_texture: Texture2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.pickup_weapon(held_player_texture)
		queue_free()
