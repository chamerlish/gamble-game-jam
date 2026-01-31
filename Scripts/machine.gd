extends StaticBody2D


class_name Machine


@export var placed: bool


@onready var _left_right_collision: CollisionPolygon2D = $LeftRightCollision
@onready var _up_down_collision: CollisionPolygon2D = $UpDownCollision


@onready var sprite: Sprite2D = $Sprite2D
@onready var panel_tweak: Panel = $HUD/Panel

@export var machine_name: String
@export var odds_of_winning: float = 0.1
@export var prize_money: int = 100
@export var price: int = 100
@export var level: int = 1
@export var MAX_LEVEL: int = 3

@onready var roll_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

# for the panel cuz when you drop it first it counts as drop
var nums_of_clicks: int 

var isDraggin: bool

var available = true
var mouse_inside := false
var player_inside := false


var broken = false




func _ready() -> void:
	
	$InteractionArea.mouse_entered.connect(func(): mouse_inside = true)
	$InteractionArea.mouse_exited.connect(func(): mouse_inside = false)
	
	panel_tweak.hide()
	GlobalMachine.all_machines_list.append(self)

func _process(delta: float) -> void:
	if mouse_inside and placed:
		if Input.is_action_just_pressed("click"):
			level = min(level + 1, MAX_LEVEL)
			Global.camera_node.trigger_shake()
			update_sprite()
	
	if player_inside:
		if broken:
			if Input.is_action_just_pressed("interact"):
				fix_machine()
				Global.amount_toolbox -= 1
	
	else:
		panel_tweak.hide()
	
	# $HUD/Panel/ProgressBar.value = $HUD/Panel/Slider.value
	z_index = GlobalMachine.get_entity_z(self)
	
	if Input.is_action_pressed("click") and not placed:
		placable_mode()
		
	if !placed:
		available = false
	
	else:
		if Global.night:
			
			pass
		

func update_sprite():
	sprite.frame_coords.y = level - 1 + (int(broken) * MAX_LEVEL) # heh this is pretty cool ain't it?

func _input(event: InputEvent) -> void:
	if not placed:
		if event.is_action_released("rotate"):
			sprite.frame_coords.x = (sprite.frame_coords.x + 1) % 4
			resolve_collisions()
		if event.is_action_released("click"):
			place_machine()
		
func placable_mode():
	var mouse_pos = get_global_mouse_position().snapped(Global.TILE_SIZE)
	
	_left_right_collision.disabled = true
	_up_down_collision.disabled = true
	
	global_position = mouse_pos
	

func resolve_collisions():
	_left_right_collision.disabled = sprite.frame_coords.x % 2 != 0
	_up_down_collision.disabled = not _left_right_collision.disabled

func place_machine():
	placed = true
	available = true
	
	resolve_collisions()

	Global.camera_node.trigger_shake()
	GlobalMachine.placed_machine_list.append(self)
	GlobalMachine.available_machine_list.append(self)
	loose_money(price)


@onready var money_loss_label = $HUD/MouseFollow/MoneyLossText
@onready var money_gain_label = $HUD/MouseFollow/MoneyGainText

func loose_money(amount: int):
	$HUD/MouseFollow.global_position = get_global_mouse_position()
	money_loss_label.text = "- " + str(amount) + " $"
	$AnimationPlayer.play("money_loss")

func win_money(amount: float):
	$HUD/MouseFollow.global_position = get_global_mouse_position()
	money_gain_label.text = "+ " + str(amount) + " $"
	$AnimationPlayer.play("money_gain")

func break_machine():
	broken = true
	available = false
	GlobalMachine.available_machine_list.erase(self)
	update_sprite()
	
func fix_machine():
	broken = false
	available = true
	GlobalMachine.available_machine_list.append(self)
	update_sprite()
	
func play_sfx():
	if roll_sfx:
		roll_sfx.play()


func _on_interaction_area_body_entered(body: Node2D) -> void:
	player_inside = body == Global.player_node


func _on_interaction_area_body_exited(body: Node2D) -> void:
	player_inside = !(body == Global.player_node)
