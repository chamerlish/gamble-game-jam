extends Node

const RATIO: Vector2i = Vector2i(7, 8)
const TILE_SIZE: Vector2 = Vector2(56, 36.5)

const GRID_SIZE: Vector2 = Vector2(112, 128)
const HALF_GRID = GRID_SIZE / 2

var night = false
signal begin_switch_night_state
signal finish_switch_night_state
signal mid_switch_night_state

signal expand
signal toolbox_use(value)
signal event(event_id)
signal finished_event
signal scored(added_score, pos)
signal money_changed(added_money, pos)
signal no_pos_money_changed(added_money)

signal win_money (amount, pos)
signal loose_money (amount, pos)

signal more_customer_event
signal inputs_reversed_event

var event_list = [
	"ALL THE MACHINES BREAKKK!!!!!!",
	"MOREE CUSTOMMERSSS MOOOREEE!!!!",
	"INPUTS ARE INVERSED!!!!!",
	"TRASH?? ITS RAININNGGG..."
]

func event_handle(event_id: int):
	match event_id:
		0:
			for machine in GlobalMachine.all_machines_list:
				machine.break_machine()
		1:
			more_customer_event.emit()
		2: 
			inputs_reversed_event.emit()
		3:
			for i in range(100):
				var trash_node := GlobalMachine.TRASH_SCENE.instantiate()
				trash_node.global_position.x = randf_range(-935, 990.0)
				trash_node.global_position.y = randf_range(-640.0, 512.0)
				print(trash_node.global_position)
				get_tree().get_root().add_child(trash_node)

var amount_toolbox: int = 0:
	set(value):
		amount_toolbox = value
		toolbox_use.emit()

var score_multiplier: float = 1.0:
	set(value):
		score_multiplier = value
		_restart_multiplier_timer()

var amount_score : int = 0

var _multiplier_timer: SceneTreeTimer
var _multiplier_token := 0

func _ready() -> void:
	
	no_pos_money_changed.emit(0)
	print(amount_money)
	
	loose_money.connect(_loose_money)
	win_money.connect(_win_money)
	scored.connect(func(added_score, pos): amount_score += added_score * score_multiplier; score_multiplier += 1)
	event_loop()

func event_loop():
	await get_tree().create_timer(60).timeout
	event.emit(randi_range(0, 3))

func _restart_multiplier_timer():
	_multiplier_token += 1
	var token = _multiplier_token

	_multiplier_timer = get_tree().create_timer(20)
	await _multiplier_timer.timeout

	# Only reset if this is the *latest* timer
	if token == _multiplier_token:
		score_multiplier = 1.0


var difficulty: int = 1
var trash_level: int = 0
const MAX_DIFFICULTY: int = 8

var camera_node: Camera2D

var amount_money: int = 300:
	set(value):
		amount_money = value
		no_pos_money_changed.emit(value)
		

func cartesian_to_isometric(cartesian: Vector2) -> Vector2:
	var iso = Vector2()
	
	iso.x = (cartesian.x - cartesian.y) * TILE_SIZE.x / RATIO.x
	iso.y = (cartesian.x + cartesian.y) * TILE_SIZE.y / RATIO.y
	return iso

var player_node: CharacterBody2D
var building_mode_node: CharacterBody2D
# To go from day to night and from night to day
func change_night_state():
	camera_node.trigger_shake(5.0)
	night = not Global.night
	begin_switch_night_state.emit()

func _loose_money(amount: int, pos) -> void:
	amount_money -= amount
	money_changed.emit(-amount, pos)

func _win_money(amount: int, pos) -> void:
	amount_money += amount
	money_changed.emit(amount, pos)
