extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer2D.play()
	$Button.pressed.connect(_button_pressed)
	
func _button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
