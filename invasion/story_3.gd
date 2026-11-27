extends Node2D

var running = true
var waiting = false


func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	waiting = true
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
	if waiting == true and Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://level1.tscn")
