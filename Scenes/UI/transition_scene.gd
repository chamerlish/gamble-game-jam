extends ColorRect

var mat := material

var duration = 1.0      # time to rise/fall
var t = 0.0
var forward = true      # true = rising, false = going away

var running = false

#func _ready() -> void:
#	Global.switch_night_state.connect(func(): running = true)
	
func _process(delta: float) -> void:
#	if running:
	transition(delta)
	


func transition(delta):
	running = true
	t += delta
	var progress = t / duration

	if forward:
		mat.set_shader_parameter("height", lerp(-1.0, 1.0, progress))
		mat.set_shader_parameter("pixel_size", lerp(0.2, 0.01, progress))
		if progress >= 1.0:
			forward = false
			t = 0.0  
			Global.mid_switch_night_state.emit()
	else:
		mat.set_shader_parameter("height", lerp(1.0, -1.0, progress))
		mat.set_shader_parameter("pixel_size", lerp(0.01, 0.2, progress))
		
		size.x 
		scale.y = -1
		
		if progress >= 1.0:
			Global.finish_switch_night_state.emit()
			queue_free()
