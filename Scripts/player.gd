extends CharacterBody2D

const MAX_SPEED := 1000.0
const ACCEL := 1200.0
const BOUNCE_MULTIPLIER := 1  # How much of the velocity to bounce back (0.5 = 50%)

var selected_machine: Machine
var post_transition_can_show: bool


var can_squish: bool = true

var speed: float

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func expand():
	position.x += Global.TILE_SIZE.y + Global.GRID_SIZE.y / 4
	position.y += Global.TILE_SIZE.x + Global.GRID_SIZE.y / 4

var input_inversed: bool

func input_reverse():
	input_inversed = true

func _ready() -> void:
	Global.inputs_reversed_event.connect(input_reverse)
	Global.expand.connect(expand)
	Global.player_node = self
	GlobalMachine.selected_machine_changed.connect(pick_machine)
	Global.mid_switch_night_state.connect(switch_player_state)
	
func switch_player_state():
	
	clear_selected_machine()
	

func animate(direction: Vector2) -> void:
	var play_MAX_SPEED: float 
	if direction.length() > 0:
		play_MAX_SPEED = max(0.5, speed / MAX_SPEED)
		if direction.length() == 1: # meaning the player is only going one way
			if abs(direction.x) > abs(direction.y): # that means that x is changing
				if direction.x > 0: # pressing right
					sprite.play("side_down", play_MAX_SPEED)
					sprite.flip_h = true
				elif direction.x < 0: # pressing left
					sprite.play("side_up", play_MAX_SPEED)
					sprite.flip_h = false
			else: # that means that the y is changing but not the x
				if direction.y > 0: # pressing up
					sprite.play("side_down", play_MAX_SPEED)
					sprite.flip_h = false
				elif direction.y < 0: # pressing down
					sprite.play("side_up", play_MAX_SPEED)
					sprite.flip_h = true
		elif direction.length() > 1: # meaning the player is going diagnal:
			if (velocity.x < 20 or velocity.y < 20):
				if abs(velocity.x) > abs(velocity.y):
					if direction.x * direction.y < 0:
						sprite.play("side", play_MAX_SPEED)
						if velocity.x > 0:
							sprite.flip_h = true
						else: 
							sprite.flip_h = false
				elif abs(velocity.x) < abs(velocity.y):
					if velocity.y > 0:
						sprite.play("down", play_MAX_SPEED)
					else:
						sprite.play("up", play_MAX_SPEED)
			elif abs(velocity.x) > 2 * abs(velocity.y):
				if direction.x > 0: # pressing right
					sprite.play("side_down", play_MAX_SPEED)
					sprite.flip_h = true
				elif direction.x < 0: # pressing left
					sprite.play("side_up", play_MAX_SPEED)
					sprite.flip_h = false
			elif abs(velocity.x) < 2 * abs(velocity.y):
				if direction.y > 0: # pressing up
					sprite.play("side_down", play_MAX_SPEED)
					sprite.flip_h = false
				elif direction.y < 0: # pressing down
					sprite.play("side_up", play_MAX_SPEED)
					sprite.flip_h = true
	else:
		play_MAX_SPEED = lerp(play_MAX_SPEED, 0.0, 0.01)
		if speed < 10:
			sprite.stop()
			sprite.frame = 3
			

var squish_timer: float = 2
func _physics_process(delta: float) -> void:
	z_index = GlobalMachine.get_entity_z(self)
	speed = velocity.length()


	var input_dir := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if input_inversed:
		input_dir *= -1

	
	if not Global.night:
		animate(input_dir)
		input_dir = Global.cartesian_to_isometric(input_dir)
		if input_dir != Vector2.ZERO:
			input_dir = input_dir.normalized()
			var target_velocity = input_dir * MAX_SPEED
			velocity = velocity.move_toward(target_velocity, ACCEL * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, 2*ACCEL/3 * delta)
	else:
		velocity = Vector2(0, 0)
		animate(velocity)

	move_and_slide()
	

	# Check for collision and bounce
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		
		velocity = velocity.bounce(collision.get_normal()) * BOUNCE_MULTIPLIER
		$SquishTimer.stop()
		
		
		# Squish only if the bounce actually changed velocity
		if speed > 20:
			$SquishTimer.start()
			if can_squish:
				if $BounceSFX.playing == false:
					$BounceSFX.volume_db = min(-5, -48 + ((speed) / (MAX_SPEED)*48)) 
					$BounceSFX.play()
				scale = Vector2(1.7, 0.4)
				can_squish = false
			

	scale = lerp(scale, Vector2(1,1), 0.2)


func pick_machine(id: int):
	clear_selected_machine()
	selected_machine = GlobalMachine.machine_list[id].instantiate()
	get_tree().get_root().add_child(selected_machine)

func clear_selected_machine():
	if selected_machine and selected_machine.placed == false:
		selected_machine.queue_free()


func _on_squish_timer_timeout() -> void:
	
	can_squish = true
