extends Area2D

var player_inside: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PickUpLabel.hide()
	GlobalMachine.entity_list.append(self)
	Global.expand.connect(expand)

func expand() -> void:
	position.x += Global.TILE_SIZE.y + 30
	position.y -= Global.TILE_SIZE.x + 30 # IDK WHY BTW

func _process(delta: float) -> void:
	if position.y > Global.player_node.position.y + 30:
		z_index = 100
	else: z_index = -1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if player_inside:
			# TODO: do this
			pass

func _on_body_exited(body: Node2D) -> void:
	if body == Global.player_node:
		$PickUpLabel.hide(); 
		player_inside = false


func _on_body_entered(body: Node2D) -> void:
	if body == Global.player_node:
		$PickUpLabel.show(); 
		player_inside = true
