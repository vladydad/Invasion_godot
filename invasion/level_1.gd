extends Node2D

@export var npc_scene: PackedScene

var npc1
var npc2
var npc3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MusicBG.play()
	npc1 = npc_scene.instantiate()
	npc1.global_position = $spawner1.global_position
	get_tree().current_scene.add_child(npc1)
	
	npc2 = npc_scene.instantiate()
	npc2.global_position = $spawner2.global_position
	get_tree().current_scene.add_child(npc2)
	
	npc3 = npc_scene.instantiate()
	npc3.global_position = $spawner3.global_position
	get_tree().current_scene.add_child(npc3)

func _process(delta):
	if npc1.is_dead == true and npc2.is_dead == true and npc3.is_dead == true:
		$CanvasLayer/Countdown.visible = true
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://level2.tscn")
