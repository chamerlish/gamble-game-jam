extends Area2D

var player_inside

func _ready() -> void:
	GlobalMachine.entity_list.append(self)
	
func _process(delta: float) -> void:
	z_index = GlobalMachine.get_entity_z(self)

func _on_body_entered(body: Node2D) -> void:
	player_inside = body == Global.player_node


func _on_body_exited(body: Node2D) -> void:
	player_inside = !(body == Global.player_node)

func _input(event: InputEvent) -> void:
	if player_inside:
		if event.is_action_pressed("interact"):
			queue_free()
