extends Area2D

var player_near = false

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_near = true


func _on_body_entered(body: Node2D) -> void:
	pass 
