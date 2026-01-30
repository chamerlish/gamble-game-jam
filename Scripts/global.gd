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

var amount_toolbox: int = 0:
	set(value):
		amount_toolbox = value
		toolbox_use.emit()

var difficulty: int = 1
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
