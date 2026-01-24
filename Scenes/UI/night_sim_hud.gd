extends Control

func _ready() -> void:
	Global.mid_switch_night_state.connect(switch_player_state)
	hide()
	
func switch_player_state():
	if Global.night:
		show()
	else:
		hide()
