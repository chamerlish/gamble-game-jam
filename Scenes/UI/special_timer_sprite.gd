extends CanvasLayer

var total_frames = 5
var frame_width = 128
var frame_height = 128

func update(time_left: float, max_time: float):
	
	var frame = int((1.0 - time_left / max_time) * total_frames)
	frame = clamp(frame, 0, total_frames - 1)

	$Control/Sprite.texture.region = Rect2(frame * frame_width, 0, frame_width, frame_height)
