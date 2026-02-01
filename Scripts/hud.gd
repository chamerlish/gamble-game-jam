extends CanvasLayer

const TRANSITION_SCENE := preload("res://Scenes/UI/transition_scene.tscn")
const EVENT_SCENE := preload("res://Scenes/UI/event.tscn")


	
func _ready() -> void:
	Global.event.connect(make_event)
	Global.begin_switch_night_state.connect(func(): add_child(TRANSITION_SCENE.instantiate()))

func make_event(event_id: int):
	var event_node = EVENT_SCENE.instantiate()
	add_child(event_node)
	event_node.start(event_id)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		Global.event.emit(2)
