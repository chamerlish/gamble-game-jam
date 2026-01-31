extends Button


@export var machine_id: int
@export var machine_scene: PackedScene

func _ready() -> void:
	#$Sprite2D.texture = 
	icon = get_machine_icon(machine_scene)
	$PriceLabel.text = str(GlobalMachine.get_machine_price(machine_id)) + "$"


func _on_button_down() -> void:
	GlobalMachine.change_selected_machine(machine_id)

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
