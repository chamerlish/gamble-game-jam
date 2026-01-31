extends Area2D

var player_inside: bool

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	await get_tree().create_timer(0.1).timeout
	
	if get_overlapping_areas().size() > 1: # with the customer area and i'm too lazy rn
		queue_free()
		
	for body in get_overlapping_bodies():
		if body.name == "Door":
			queue_free()
			
	
	Global.trash_level += 1

func _on_body_entered(body: Node2D) -> void:
	player_inside = body == Global.player_node


func _on_body_exited(body: Node2D) -> void:
	player_inside = !(body == Global.player_node)

func _input(event: InputEvent) -> void:
	if player_inside:
		if event.is_action_pressed("interact"):
			clear_trash()

func clear_trash():
	Global.trash_level -= 1
	scale.x = lerp(1.0, 1.7, 0.1)
	await get_tree().create_timer(0.04).timeout
	scale.y = lerp(1.0, 1.7, 0.1)
	$AnimatedSprite2D.modulate.a = lerp(1.0, 0.0, 0.1)
	await get_tree().create_timer(0.08).timeout
	queue_free()
