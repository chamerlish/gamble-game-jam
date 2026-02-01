extends Control

var event_id: int

func start(id: int) -> void:
	$AnimationPlayer.play("play")
	$EventLabel.text = Global.event_list[id]
	event_id = id

func throw_back_global():
	Global.event_handle(event_id)
