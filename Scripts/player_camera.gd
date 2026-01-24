extends Camera2D


const CAMERA_FOLLOW_SPEED := 5.0

const SHAKE_FADE: float = 10.0

var _shake_strengh: float = 0.0

func _ready() -> void:
	Global.camera_node = self

func trigger_shake(_shake_strengh: float = 10.0) -> void:
	self._shake_strengh = _shake_strengh

func _process(delta: float) -> void:
	camera_follow_player(delta)
	
	if _shake_strengh > 0:
		_shake_strengh = lerp(_shake_strengh, 0.0, SHAKE_FADE * delta)
		offset = Vector2(randf_range(-_shake_strengh, _shake_strengh), randf_range(-_shake_strengh, _shake_strengh))


func camera_follow_player(delta: float) -> void:
	global_position = global_position.lerp(
		Global.player_node.global_position,
		CAMERA_FOLLOW_SPEED * delta
	)
