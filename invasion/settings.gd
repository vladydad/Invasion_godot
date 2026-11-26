extends Control

@onready var sound_toggle: CheckButton = find_child("CheckButton", true, false)
@onready var back_button: Button = find_child("Button", true, false)

func _ready() -> void:
	var master_bus = AudioServer.get_bus_index("Master")
	
	if sound_toggle:
		sound_toggle.button_pressed = not AudioServer.is_bus_mute(master_bus)
		sound_toggle.toggled.connect(_on_sound_toggled)
	
	if back_button:
		back_button.pressed.connect(_on_back_pressed)

func _on_sound_toggled(toggled_on: bool) -> void:
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus, not toggled_on)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
