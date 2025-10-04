extends Node2D

var start = Vector2(4,4)
var end = Vector2(10,10)
@onready
var tileMap = $"../../TileMapLayer"

func _enter_tree()->void:
	
	pass
	
func _ready()->void:
	for i in range(start.x, end.x):
		for j in range(start.y, end.y):
			tileMap.set_cell(Vector2(i,j),1,Vector2(3,1)) # floor
			if i == start.x or j == start.y or i == end.x -1 or j == end.y -1 :
				tileMap.set_cell(Vector2(i,j), 1, Vector2(0,1)) # wall
			
	pass
