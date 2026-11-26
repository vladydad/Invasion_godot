extends Control

@onready var back_button: Button = find_child("Button", true, false)

func _ready() -> void:
	if back_button:
		back_button.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
