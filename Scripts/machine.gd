extends StaticBody2D


class_name Machine


@export var placed: bool
# @export var machine: Machine

@onready var collision: CollisionPolygon2D = $CollisionPolygon2D
@onready var sprite: Sprite2D = $Sprite2D

@export var texture: CompressedTexture2D
@export var machine_name: String
@export var odds_of_winning: float
@export var prize_money: int

func _ready() -> void:
	# TODO: fix this
	texture = $Sprite2D.texture
	print(texture)


func _process(delta: float) -> void:
	z_index = GlobalMachine.get_entity_z(self)
	
	if placed == false:
		placable_mode()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and not placed:
		place_machine()
		
func placable_mode():
	var mouse_pos = get_global_mouse_position().snapped(Global.TILE_SIZE)
	
	collision.disabled = true
	sprite.modulate.a = 0.5
	
	global_position = mouse_pos
	
func place_machine():
	placed = true
	collision.disabled = false
	sprite.modulate.a = 1
	GlobalMachine.placed_machine_list.append(self)
