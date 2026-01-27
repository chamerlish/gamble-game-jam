extends StaticBody2D


@export var next_wave: int 
var can_spawn: bool = true

func _ready() -> void:
	
	spawn_customer(randi_range(3, 7))

func spawn_customer(nums_cus: int) -> void:
	for i in nums_cus:
		#if can_spawn:
		get_tree().get_root().add_child(GlobalMachine.customer_scene.instantiate())
		await get_tree().create_timer(1/ float(Global.difficulty)).timeout
		if randi() % 2 == 0 and Global.difficulty < Global.MAX_DIFFICULTY: Global.difficulty += 1 

func _on_wave_delay_timeout() -> void:
	spawn_customer(randi_range(3, 7))


func _on_spawn_timer_timeout() -> void:
	can_spawn = true
