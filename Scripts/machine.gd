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
@onready var smoke_fx: GPUParticles2D = $SmokeParticle

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
			print(10* 1+ 1/ Global.score_multiplier)
			Global.camera_node.trigger_shake(10 * Global.score_multiplier)
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
		if event.is_action_released("click") and can_place:
			place_machine()

var can_place: bool = true

func placable_mode():
	var areas = $OverlappingArea.get_overlapping_areas()
	var bodies = $OverlappingArea.get_overlapping_areas()
	
	
	
	if areas.size() > 0 and bodies.size() > 0:
		print(areas[0])
		can_place = false
		modulate = Color(0.9, 0.1, 0.1)
	else:
		can_place = true
		modulate = Color(1, 1, 1)
	
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
	Global.scored.emit(100, global_position)
	
	resolve_collisions()

	Global.camera_node.trigger_shake(10 * Global.score_multiplier)
	GlobalMachine.placed_machine_list.append(self)
	GlobalMachine.available_machine_list.append(self)
	Global.loose_money.emit(price, global_position)



func break_machine():
	broken = true
	available = false
	GlobalMachine.available_machine_list.erase(self)
	smoke_fx.emitting = true
	update_sprite()
	
func fix_machine():
	broken = false
	available = true
	
	Global.scored.emit(50, global_position)
	smoke_fx.emitting = false
	GlobalMachine.available_machine_list.append(self)
	update_sprite()
	
func play_sfx():
	if roll_sfx:
		roll_sfx.play()


func _on_interaction_area_body_entered(body: Node2D) -> void:
	player_inside = body == Global.player_node


func _on_interaction_area_body_exited(body: Node2D) -> void:
	player_inside = !(body == Global.player_node)
