extends Control

func _process(delta: float) -> void:
	if Global.night == true:
		show()
	else:
		hide()
