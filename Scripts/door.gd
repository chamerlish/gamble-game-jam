extends StaticBody2D


@export var next_wave: int 
var can_spawn: bool = true

func _ready() -> void:
	
	next_wave = generate_next_wave()
	
	spawn_customer(next_wave)

func spawn_customer(nums_cus: int) -> void:
	for i in nums_cus:
		#if can_spawn:
		get_tree().get_root().add_child(GlobalMachine.customer_scene.instantiate())
		await get_tree().create_timer(1/ float(Global.difficulty)).timeout

func generate_next_wave() -> int:
	return randi_range(2, 2 + Global.difficulty)

func _on_wave_delay_timeout() -> void:
	next_wave = generate_next_wave()
	print(next_wave)
	spawn_customer(next_wave)
	if randi_range(0, 10) < 8 and Global.difficulty < Global.MAX_DIFFICULTY: Global.difficulty += 1


func _on_spawn_timer_timeout() -> void:
	can_spawn = true
