extends CharacterBody2D


const SPEED = 10000.0
const JUMP_VELOCITY = -400.0

enum State {
	Wondering,
	Moving,
	Playing
}

enum Class {
	Broke, 
	Middle,
	Rich
}

func _ready() -> void:
	GlobalMachine.customer_list.append(self)

var current_state: State

var machine_in_use: Machine

var target_direction: Vector2i
var target_position: Vector2


func _on_interraction_collider_body_entered(body: Node2D) -> void:
	
	if body == machine_in_use:
		$PlayingTimer.start()
		current_state = State.Playing

func _physics_process(delta: float) -> void:
	z_index = GlobalMachine.get_entity_z(self)

	
	match current_state:
		State.Moving:
			var dir := (target_position - global_position).normalized()
			velocity = dir * SPEED * delta
		State.Playing:
			velocity = Vector2(0, 0)
	move_and_slide()



func _on_wondering_moving_timer_timeout() -> void:
	var rand_want_play = randi_range(1, 10)
	if rand_want_play <= 8: # they want play
		print("i wanna play")
		if GlobalMachine.available_machine_list:
			machine_in_use = get_random_machine()
			
			machine_in_use.available = false
			machine_in_use.get_node("Sprite2D").modulate.r = 10
			GlobalMachine.available_machine_list.erase(machine_in_use)
			
			$WonderingMovingTimer.stop()
			target_position = machine_in_use.position
			current_state = State.Moving
			
func get_random_machine() -> Machine:
	GlobalMachine.available_machine_list.shuffle()
	return GlobalMachine.available_machine_list[0]


func _on_playing_timer_timeout() -> void:
	machine_in_use.available = true
	current_state = State.Wondering
	machine_in_use.get_node("Sprite2D").modulate.r = 0
	print("done playing")
	$WonderingMovingTimer.start()
