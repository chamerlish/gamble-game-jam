extends Node

const RATIO: Vector2i = Vector2i(7, 8)
const TILE_SIZE: Vector2 = Vector2(56, 36.5)

const GRID_SIZE: Vector2 = Vector2(112, 128)
const HALF_GRID = GRID_SIZE / 2

var night = false
signal begin_switch_night_state
signal finish_switch_night_state
signal mid_switch_night_state

func cartesian_to_isometric(cartesian: Vector2) -> Vector2:
	var iso = Vector2()
	
	iso.x = (cartesian.x - cartesian.y) * TILE_SIZE.x / RATIO.x
	iso.y = (cartesian.x + cartesian.y) * TILE_SIZE.y / RATIO.y
	return iso

# To go from day to night and from night to day
func change_night_state():
	night = not Global.night
	begin_switch_night_state.emit()

	
