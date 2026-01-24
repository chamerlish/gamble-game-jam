extends CanvasLayer

const TRANSITION_SCENE := preload("res://Scenes/UI/transition_scene.tscn")

func _ready() -> void:
	Global.begin_switch_night_state.connect(func(): add_child(TRANSITION_SCENE.instantiate()))
