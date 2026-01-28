extends Node2D


func _ready() -> void:
	Global.wall_node = self

func expend() -> void:
	scale.x += 0.182
	scale.y += 0.182
