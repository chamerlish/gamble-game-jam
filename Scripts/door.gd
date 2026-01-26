extends StaticBody2D

@export var next_wave: int 

func spawn_customer(nums_cus: int) -> void:
	for i in nums_cus:
		get_tree().get_root().add_child(GlobalMachine.customer_scene.instantiate())


func _on_spawn_delay_timeout() -> void:
	spawn_customer(randi_range(3, 7))
