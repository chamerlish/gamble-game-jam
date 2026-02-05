extends ColorRect

var music = AudioServer.get_bus_index("Music")


func _process(delta: float) -> void:
	if Global.amount_money < 0:
		activate()
	else:
		$DeathTimer.stop()
		AudioServer.set_bus_effect_enabled(music, 0, false)
		modulate.a = 0
	
	
func activate():
	AudioServer.set_bus_effect_enabled(music, 0, true)
	$DeathTimer.start()
	modulate.a = 0.173
func _on_death_timer_timeout() -> void:
	get_tree().change_scene_to_packed(load("res://Scenes/UI/game_over.tscn"))
