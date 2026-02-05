extends TextureButton

@export var level = 1
@export var base_price: int = 500

var _shake_strengh: float
const SHAKE_FADE: float = 10.0

func _ready() -> void:
	$PriceLabel.text = str(get_price()) + "$"

func _on_pressed() -> void:
	if Global.amount_money > 0:
		Global.expand.emit()
		Global.scored.emit(1000, Global.player_node.global_position)
		Global.loose_money.emit(get_price(), global_position)
		level += 1
		$PriceLabel.text = str(get_price()) + "$"
		$AudioStreamPlayer.play()
	else:
		_shake_strengh = 10

func get_price() -> int:
	return base_price * level

func _process(delta: float) -> void:
	if _shake_strengh > 0:
		_shake_strengh = lerp(_shake_strengh, 0.0, SHAKE_FADE * delta)
		position = Vector2(randf_range(-_shake_strengh, _shake_strengh), randf_range(-_shake_strengh, _shake_strengh))
