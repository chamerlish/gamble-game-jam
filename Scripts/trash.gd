extends Area2D

var player_inside: bool

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	
	if get_overlapping_areas().size() > 1: # with the customer area and i'm too lazy rn
		queue_free()
		
	for body in get_overlapping_bodies():
		if body.name == "Door":
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	player_inside = body == Global.player_node


func _on_body_exited(body: Node2D) -> void:
	player_inside = !(body == Global.player_node)

func _input(event: InputEvent) -> void:
	if player_inside:
		if event.is_action_pressed("interact"):
			queue_free()
