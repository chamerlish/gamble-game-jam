extends CharacterBody2D

const SPEED = 120.0

enum State {
	Wondering, # idle / standing
	Moving,
	Playing
}

@export var jump_speed : float = 9
@export var jump_height := 20

var current_state: State = State.Wondering
var machine_in_use: Machine

var target_direction: Vector2
var target_position: Vector2

var time := 0.0
var dir := Vector2.ZERO

func _ready() -> void:
	scale = Vector2(1.7, 0.4)
	GlobalMachine.customer_list.append(self)

	target_direction = get_random_direction()
	$WonderingMovingTimer.start()

func _physics_process(delta: float) -> void:
	time += delta
	scale = lerp(scale, Vector2.ONE, 0.1)
	z_index = GlobalMachine.get_entity_z(self)

	match current_state:
		State.Moving:
			walk_around(time)
			velocity = target_direction * SPEED

		State.Wondering:
			velocity = Vector2.ZERO

		State.Playing:
			velocity = Vector2.ZERO

	move_and_slide()

func walk_around(t: float) -> void:
	$Sprite2D.position.y = sin(t * jump_speed) * jump_height

func _on_wondering_moving_timer_timeout() -> void:
	match current_state:
		State.Wondering:
			# decide what to do next
			if wants_to_play():
				try_go_play()
			else:
				target_direction = get_random_direction()
				current_state = State.Moving

		State.Moving:
			current_state = State.Wondering

func wants_to_play() -> bool:
	return randi_range(1, 10) <= 3

func try_go_play() -> void:
	if GlobalMachine.available_machine_list.is_empty():
		return

	machine_in_use = get_random_machine()
	machine_in_use.available = false
	GlobalMachine.available_machine_list.erase(machine_in_use)

	machine_in_use.get_node("Sprite2D").modulate.r = 10

	target_position = machine_in_use.global_position
	target_direction = (target_position - global_position).normalized()

	current_state = State.Moving

func _on_interraction_collider_body_entered(body: Node2D) -> void:
	if body == machine_in_use:
		current_state = State.Playing
		$PlayingTimer.start()

func _on_playing_timer_timeout() -> void:
	machine_in_use.available = true
	GlobalMachine.available_machine_list.append(machine_in_use)
	machine_in_use.get_node("Sprite2D").modulate.r = 0.5

	machine_in_use = null
	current_state = State.Wondering

func get_random_direction() -> Vector2:
	return Vector2(
		randf_range(-1, 1),
		randf_range(-1, 1)
	).normalized()

func get_random_machine() -> Machine:
	GlobalMachine.available_machine_list.shuffle()
	return GlobalMachine.available_machine_list[0]
