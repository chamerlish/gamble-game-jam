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
signal scored(added_score, pos)

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

var score_multiplier: float = 1:
	set(value):
		score_multiplier = value
		await get_tree().create_timer(20).timeout
		score_multiplier = 1

var difficulty: int = 1
var trash_level: int = 0
const MAX_DIFFICULTY: int = 8

var camera_node: Camera2D

var amount_money: float

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

func loose_money(amount: int) -> void:
	amount_money -= amount
