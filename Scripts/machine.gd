extends StaticBody2D

@export var placed: bool
@export var player: CharacterBody2D

@export var GRID_SIZE: Vector2
@onready var collision: CollisionPolygon2D = $CollisionPolygon2D
@onready var sprite: Sprite2D = $Sprite2D


func _process(delta: float) -> void:
	if player.global_position.y > global_position.y: # the player is below the machine
		z_index = 0
	else:
		z_index = 2
		
	print(z_index)
	
	if placed == false:
		placable_mode()
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("click") and not placed:
		placed = true
		collision.disabled = false
		sprite.modulate.a = 1
		
func placable_mode():
	var mouse_pos = get_global_mouse_position()
	print(mouse_pos)

	# convert screen pos to isometric grid coordinates
	var iso_x = int(mouse_pos.x / GRID_SIZE.x)
	var iso_y = int(mouse_pos.y / GRID_SIZE.y)
	collision.disabled = true
	
	sprite.modulate.a = 0.5

	# snap to grid in world space
	global_position.x = (iso_x - iso_y) * (GRID_SIZE.x / 2)
	global_position.y = (iso_x + iso_y) * (GRID_SIZE.y / 2)
	
	global_position = mouse_pos
	
