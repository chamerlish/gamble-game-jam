extends Area2D

var player_inside: bool



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PickUpLabel.hide()
	GlobalMachine.entity_list.append(self)
	Global.expand.connect(expand)

func expand() -> void:
	position.x += Global.TILE_SIZE.y + Global.GRID_SIZE.y / 4
	position.y -= Global.TILE_SIZE.x + Global.GRID_SIZE.y / 4 # IDK WHY BTW

func _process(delta: float) -> void:
	if position.y > Global.player_node.position.y + 30:
		z_index = 100
	else: z_index = -1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if player_inside:
			Global.amount_toolbox = 3

func _on_body_exited(body: Node2D) -> void:
	if body == Global.player_node:
		$PickUpLabel.hide(); 
		player_inside = false


func _on_body_entered(body: Node2D) -> void:
	if body == Global.player_node:
		$PickUpLabel.show(); 
		player_inside = true
