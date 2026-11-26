extends Node2D

@export var npc_scene: PackedScene

var npc1
var npc2
var npc3
var npc4
var npc5

func _ready() -> void:
	$AnimatedSprite2D.play() 
	$AnimatedSprite2D2.play()
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
	
	npc4 = npc_scene.instantiate()
	npc4.global_position = $spawner4.global_position
	get_tree().current_scene.add_child(npc4)
	
	npc5 = npc_scene.instantiate()
	npc5.global_position = $spawner5.global_position
	get_tree().current_scene.add_child(npc5)

func _process(delta):
	if npc1.is_dead and npc2.is_dead and npc3.is_dead and npc4.is_dead and npc5.is_dead:
		$CanvasLayer/Countdown.visible = true
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://level3.tscn")
