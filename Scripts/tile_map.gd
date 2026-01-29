extends Node2D

@onready var tileset: TileMapLayer = $TileSet

func _ready() -> void:
	Global.expand.connect(expand)
	draw_terrain()

var max_size: Vector2i = Vector2i(-10, -10) # top
var min_size: Vector2i = Vector2i(8, 9) # bottom

func expand():
	max_size.x -= 2
	max_size.y -= 2
	min_size.x += 2
	min_size.y += 2
	draw_terrain()


func draw_terrain():
	for cell_x in range(max_size.x, min_size.x + 1):
		for cell_y in range(max_size.y, min_size.y + 1):
			var cell = Vector2i(cell_x, cell_y)
			tileset.set_cell(cell, 0, Vector2i(1, 0))
