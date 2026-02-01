extends CanvasLayer

const TRANSITION_SCENE := preload("res://Scenes/UI/transition_scene.tscn")
const EVENT_SCENE := preload("res://Scenes/UI/event.tscn")
const SCORE_SCENE := preload("res://Scenes/UI/score_animation.tscn")


	
func _ready() -> void:
	Global.event.connect(make_event)
	Global.scored.connect(scored)
	Global.begin_switch_night_state.connect(func(): add_child(TRANSITION_SCENE.instantiate()))

func scored(score_amount, pos):
	var score_node = SCORE_SCENE.instantiate()
	get_tree().get_root().add_child(score_node)
	score_node.global_position = pos
	score_node.start(score_amount)

func make_event(event_id: int):
	var event_node = EVENT_SCENE.instantiate()
	add_child(event_node)
	event_node.start(event_id)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		Global.event.emit(2)
