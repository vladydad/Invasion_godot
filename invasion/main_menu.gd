extends Control

func _ready():
	$PlayButton.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	print("Play trykket")
