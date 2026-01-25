extends CharacterBody2D

const SPEED := 1000.0
const ACCEL := 1200.0
const BOUNCE_MULTIPLIER := 1  # How much of the velocity to bounce back (0.5 = 50%)

var selected_machine: Machine
var post_transition_can_show: bool

var can_squish: bool = true

@export var min_vel_y_stun: int = 70

func _ready() -> void:
	Global.player_node = self
	GlobalMachine.selected_machine_changed.connect(pick_machine)
	Global.mid_switch_night_state.connect(switch_player_state)
	
func switch_player_state():
	if Global.night:
		night_mode()
	else:
		$Sprite2D.show()
	
	clear_selected_machine()
	

var squish_timer: float = 2
func _physics_process(delta: float) -> void:
	z_index = GlobalMachine.get_entity_z(self)
	
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
		velocity = velocity.move_toward(Vector2.ZERO, 2*ACCEL/3 * delta)


	move_and_slide()
	

	# Check for collision and bounce
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		
		velocity = velocity.bounce(collision.get_normal()) * BOUNCE_MULTIPLIER
		$SquishTimer.stop()
		
		# Squish only if the bounce actually changed velocity
		if velocity.length() > 20:
			$SquishTimer.start()
			if can_squish:
				scale = Vector2(1.7, 0.4)
				can_squish = false
			

	scale = lerp(scale, Vector2(1,1), 0.2)

func night_mode():
	$Sprite2D.hide()

func pick_machine(id: int):
	clear_selected_machine()
	selected_machine = GlobalMachine.machine_list[id].instantiate()
	get_tree().get_root().add_child(selected_machine)

func clear_selected_machine():
	if selected_machine and selected_machine.placed == false:
		selected_machine.queue_free()


func _on_squish_timer_timeout() -> void:
	
	can_squish = true
