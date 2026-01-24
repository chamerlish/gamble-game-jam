extends CharacterBody2D

const SPEED := 200.0
const ACCEL := 1200.0

@export var player_camera: Camera2D
@export var camera_follow_speed := 5.0

var selected_machine: Machine

var post_transition_can_show: bool

func _ready() -> void:
	player_camera.global_position = global_position

	GlobalMachine.selected_machine_changed.connect(pick_machine)
	Global.mid_switch_night_state.connect(switch_player_state)
	
func switch_player_state():
	if Global.night:
		night_mode()
	else:
		$Sprite2D.show()
	
	clear_selected_machine()
	
func _physics_process(delta: float) -> void:
	
#	if Global.night:
#		night_mode()
#	else:
#		if post_transition_can_show:
#			$Sprite2D.show()
	
	if Input.is_action_just_pressed("ui_accept"):
		Global.change_night_state()
		
	
	var input_dir := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	input_dir = Global.cartesian_to_isometric(input_dir)
	
	if input_dir != Vector2.ZERO and not Global.night:
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

func night_mode():
	$Sprite2D.hide()


func pick_machine(id: int):
	clear_selected_machine()
	print(id)
	selected_machine = GlobalMachine.machine_list[id].instantiate()
	selected_machine.player = self  
	get_tree().get_root().add_child(selected_machine)

func clear_selected_machine():
	if selected_machine and selected_machine.placed == false:
		selected_machine.queue_free()
