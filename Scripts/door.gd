extends StaticBody2D


@export var next_wave: int 
var can_spawn: bool = true

func _ready() -> void:
	
	next_wave = generate_next_wave()
	spawn_customer(next_wave)
	Global.expand.connect(expand)

func expand() -> void:
	position.x -= Global.TILE_SIZE.y + Global.GRID_SIZE.y / 4
	position.y -= Global.TILE_SIZE.x + Global.GRID_SIZE.y / 4

func _process(delta: float) -> void:
	if position.y > Global.player_node.position.y + 30:
		z_index = 100
	else: z_index = -1

func spawn_customer(nums_cus: int) -> void:
	#$Bell.play()
	for i in nums_cus:
		#if can_spawn:
		var customer := GlobalMachine.customer_scene.instantiate()
		get_tree().get_root().add_child(customer)
		customer.global_position = global_position
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
