extends Area2D

var speed = 700
var direction = Vector2.UP

func _ready():
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)


func _physics_process(delta):
	global_position += direction * speed * delta


func _on_body_entered(body):
	if body.get("weapon") != null:
		return   # это игрок
	_hit(body)
	queue_free()


func _on_area_entered(area):
	# другие пули и зоны обнаружения NPC пропускаем
	if area.is_in_group("bullets") or area.name == "DetectionArea" or area.name == "AttackRange":
		return
	if _hit(area):
		queue_free()


# идём вверх по родителям, пока не найдём того, у кого есть die()
func _hit(node) -> bool:
	var n = node
	while n != null and n != get_tree().current_scene:
		if n.get("weapon") != null:
			return false   # не убиваем игрока
		if n.has_method("die"):
			n.die()
			return true
		n = n.get_parent()
	return false
