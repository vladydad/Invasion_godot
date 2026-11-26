extends Control

func _ready():
	$PlayButton.pressed.connect(_on_play_pressed)
	$Button.pressed.connect(_on_button_pressed)
	$Button2.pressed.connect(_on_button2_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://story1.tscn")


func _on_button_pressed():
	get_tree().change_scene_to_file("res://settings.tscn")

func _on_button2_pressed():
	get_tree().change_scene_to_file("res://CREDITS.tscn")
