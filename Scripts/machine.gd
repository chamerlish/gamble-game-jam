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
@export var price: int = 100


var available = true

func _ready() -> void:
	# TODO: fix this
	texture = $Sprite2D.texture
	print(texture)


func _process(delta: float) -> void:
	z_index = GlobalMachine.get_entity_z(self)
	
	if placed == false:
		available = false
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
	available = true
	collision.disabled = false
	sprite.modulate.a = 1
	Global.camera_node.trigger_shake()
	GlobalMachine.placed_machine_list.append(self)
	GlobalMachine.available_machine_list.append(self)
	loose_money(price)

func loose_money(amount: int):
	$MoneyLossText.text = "- " + str(amount) + " $"
	$AnimationPlayer.play("money_loss")

func win_money(amount: float):
	$MoneyGainText.text = "+ " + str(amount) + " $"
	$AnimationPlayer.play("money_gain")
