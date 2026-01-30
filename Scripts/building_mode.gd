extends CharacterBody2D


const SPEED := 40000.0

func _ready() -> void:
	Global.building_mode_node = self

func _physics_process(delta: float) -> void:
	
	var input_dir := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	
	
	input_dir = Global.cartesian_to_isometric(input_dir)
	if input_dir != Vector2.ZERO and Global.night:
		input_dir = input_dir.normalized()
		velocity = input_dir * SPEED * delta
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED * delta)

	
	

	move_and_slide()
