extends Control

var event_id: int

func start(id: int) -> void:
	$AnimationPlayer.play("play")
	$UI/EventLabel.text = Global.event_list[id]
	Global.event.connect(set_timer)
	event_id = id

func throw_back_global():
	$EffectTimer.start()
	Global.event_handle(event_id)
	
@onready var effect_timer: Timer = $EffectTimer

func set_timer(id: int):
	match id: # machine, customers, input, trash
		1: 
			effect_timer.wait_time = 20
			effect_timer.start()
		2:
			effect_timer.wait_time = 30
			effect_timer.start()


func _on_effect_timer_timeout() -> void:
	Global.finished_event.emit()
	queue_free()
