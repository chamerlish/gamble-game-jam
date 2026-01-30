extends TextureRect



func _ready() -> void:
	hide()
	Global.toolbox_use.connect(pick_up)
	Global.begin_switch_night_state.connect(func(): if Global.night: hide())
	Global.finish_switch_night_state.connect(func(): if not Global.night and Global.amount_toolbox > 0: show())
	
func pick_up():
	show()
	$AmountLabel.text = str(Global.amount_toolbox)
