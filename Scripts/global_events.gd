extends Node


var event_scene = preload("res://Scenes/UI/event.tscn")

func make_event():
	get_tree().get_root().add_child(event_scene.instantiate())
	print("hel")
	
func _ready() -> void:
	make_event()
