extends Node2D



func _ready() -> void:
	Global.expand.connect(expand)

#func expand() -> void:
#	scale.x += 1 / Global.TILE_SIZE.x
#	scale.y += 1 / Global.TILE_SIZE.y


func expand():
	$BOTTOM.position.y += Global.GRID_SIZE.y 
	$LEFT.position.y += Global.GRID_SIZE.y
	$TOP.position.y -= Global.GRID_SIZE.y
	$RIGHT.position.y -= Global.GRID_SIZE.y 
