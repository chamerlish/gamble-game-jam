extends Timer



func _process(delta: float) -> void:
	$SpecialTimerSprite.update(time_left, wait_time)

func _on_timeout() -> void:
	Global.loose_money.emit(100, Global.player_node.global_position)
