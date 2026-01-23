extends StaticBody2D

@export var placed: bool
@export var player: CharacterBody2D
@export var machine: Machine



@onready var collision: CollisionPolygon2D = $CollisionPolygon2D
@onready var sprite: Sprite2D = $Sprite2D



func _process(delta: float) -> void:
	if player.global_position.y > global_position.y: # the player is below the machine
		z_index = 0
	else: # the player is above the machine
		z_index = 2
		

	
	if placed == false:
		placable_mode()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and not placed:
		placed = true
		collision.disabled = false
		sprite.modulate.a = 1
		
func placable_mode():
	var mouse_pos = get_global_mouse_position().snapped(Global.TILE_SIZE)
	
	collision.disabled = true
	sprite.modulate.a = 0.5
	
	global_position = mouse_pos
	
