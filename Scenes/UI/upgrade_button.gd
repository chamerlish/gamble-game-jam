extends TextureButton

@export var level = 1
@export var base_price: int = 300

var _shake_strengh: float
const CAMERA_FOLLOW_SPEED := 5.0
const SHAKE_FADE: float = 10.0

func _ready() -> void:
	$PriceLabel.text = str(get_price()) + "$"
	Global.amount_money = 10000

func _on_pressed() -> void:
	if Global.amount_money > 0:
		Global.expand.emit()
		Global.loose_money(get_price())
		level += 1
		$PriceLabel.text = str(get_price()) + "$"
	else:
		_shake_strengh = 10

func get_price() -> int:
	return base_price * level

func _process(delta: float) -> void:
	if _shake_strengh > 0:
		_shake_strengh = lerp(_shake_strengh, 0.0, SHAKE_FADE * delta)
		position = Vector2(randf_range(-_shake_strengh, _shake_strengh), randf_range(-_shake_strengh, _shake_strengh))
