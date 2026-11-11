extends Area2D

var player_near = false

func _on_area_2d_body_entered(body):
	print("PLAYER ENTERED: ", body.name)
	if body.name == "Player":
		player_near = true
