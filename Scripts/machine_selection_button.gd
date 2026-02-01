extends Button


@export var machine_id: int
@export var machine_scene: PackedScene

var _shake_strengh: float
const SHAKE_FADE: float = 10.0

var base_position

func _ready() -> void:
	#$Sprite2D.texture = 
	icon = get_machine_icon(machine_scene)
	$PriceLabel.text = str(GlobalMachine.get_machine_price(machine_id)) + "$"
	base_position = position


func _process(delta: float) -> void:
	
	if _shake_strengh > 0:
		_shake_strengh = lerp(_shake_strengh, 0.0, SHAKE_FADE * delta)
		
		var offset = Vector2(randf_range(-_shake_strengh, _shake_strengh), 
							 randf_range(-_shake_strengh, _shake_strengh))
		position += offset

func _on_button_down() -> void:
	if Global.amount_money > 0:
		GlobalMachine.change_selected_machine(machine_id)
	else:
		_shake_strengh = 10
	
func get_machine_icon(machine_scene: PackedScene) -> Texture2D:
	var machine = machine_scene.instantiate()
	var sprite := machine.get_node("Sprite2D") as Sprite2D

	sprite.frame = 0

	var frame_size = Vector2(
		float(sprite.texture.get_width()) / sprite.hframes,
		float(sprite.texture.get_height()) / sprite.vframes
	)

	var frame_x = sprite.frame % sprite.hframes
	var frame_y = float(sprite.frame) / sprite.hframes

	var frame_origin = Vector2(frame_x, frame_y) * frame_size

	var square_size = min(frame_size.x, frame_size.y)
	var square_offset = (frame_size - Vector2(square_size, square_size)) / 2.0

	var atlas := AtlasTexture.new()
	atlas.atlas = sprite.texture
	atlas.region = Rect2(
		frame_origin + square_offset,
		Vector2(square_size, square_size)
	)

	return atlas
