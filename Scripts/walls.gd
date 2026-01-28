extends Node2D


func _ready() -> void:
	Global.expand.connect(expand)

func expand() -> void:
	scale.x += 0.182
	scale.y += 0.182
