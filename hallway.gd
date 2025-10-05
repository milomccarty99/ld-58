extends Node2D

@export var s_loc : Vector2 = Vector2(0,0)
@export var t_loc : Vector2 = Vector2(50, 0)

var roomA = 5
var roomB = 3
var roomC = 2
var roomD = 3
@onready
var tile_map_layer = $"../../TileMapLayer"
var series = []

			

func _ready() -> void:
	series.resize(7)
	for i in range(0,series.size()):
		series[i] = randi() % 10
	tile_map_layer.clear()
	var countdown = 0
	var iter = 0
	for i in range(s_loc.x, t_loc.x):
		tile_map_layer.set_cell(Vector2(i,0),1,Vector2())
		if countdown == 0 and iter < series.size():
			
			for x in range(0, series[iter]):
				for y in range(0, series[iter]):
					tile_map_layer.set_cell(Vector2(i + x, y + 1), 1, Vector2(iter + 1,0))
			countdown = series[iter] + 2
			iter += 1
		else:
			countdown -= 1
		#var h_wy = preload("res://images/player_x.png")
		#h_wy.call("can_translate_messages")
		
