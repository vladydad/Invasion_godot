extends Node2D

var running = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while running == true:
		$Next.visible = true
		await get_tree().create_timer(0.5).timeout
		$Next.visible = false
		await get_tree().create_timer(0.5).timeout
		$Next.visible = true
		await get_tree().create_timer(0.5).timeout
		$Next.visible = false
		await get_tree().create_timer(0.5).timeout

func _physics_process(delta: float) -> void:
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://story2.tscn")
