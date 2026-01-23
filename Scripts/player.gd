extends CharacterBody2D

const SPEED := 200.0
const ACCEL := 1200.0

@export var player_camera: Camera2D
@export var camera_follow_speed := 5.0


func _ready() -> void:
	player_camera.global_position = global_position


func _physics_process(delta: float) -> void:
	var input_dir := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	input_dir = Global.cartesian_to_isometric(input_dir)
	
	if input_dir != Vector2.ZERO:
		input_dir = input_dir.normalized()
		var target_velocity = input_dir * SPEED
		velocity = velocity.move_toward(target_velocity, ACCEL * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCEL * delta)


	move_and_slide()
	camera_follow_player(delta)

func camera_follow_player(delta: float) -> void:
	player_camera.global_position = player_camera.global_position.lerp(
		global_position,
		camera_follow_speed * delta
	)
