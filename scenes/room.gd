extends Node2D

#var start = Vector2(4,4)
#var end = Vector2(10,10)
var width = 10
var height = 10
var start_point = Vector2(0,0)
var wall_thickness = 1
var ss_i = 1
var floor_sample = Vector2(3, 6)
var wall_sample = Vector2(0, 0)
var door_dir = ["none"]
var walls = 0
@onready
var tileMap = $"../../TileMapLayer"

func _enter_tree()->void:
	
	pass
	
func _ready()->void:
	for i in range(0, width):
		for j in range(0, height):
			tileMap.set_cell(Vector2(start_point.x * width + i,start_point.y * height + j),ss_i, floor_sample)
			var running_walls = walls
			if i == width - 1 and running_walls % 8 == running_walls: # right wall
				tileMap.set_cell(Vector2(start_point.x * width + i, start_point.y * height + j), ss_i, wall_sample)
			running_walls = running_walls % 8
			if  j == height - 1 and running_walls % 4 == running_walls: # down wall
				tileMap.set_cell(Vector2(start_point.x * width + i, start_point.y * height + j), ss_i, wall_sample)
			running_walls = running_walls % 4
			if i == 0 and running_walls % 2 == running_walls: # left wall
				tileMap.set_cell(Vector2(start_point.x * width + i, start_point.y * height + j), ss_i, wall_sample)
			running_walls = running_walls % 2
			if j == 0 and running_walls % 1 == running_walls: # up  wall
				tileMap.set_cell(Vector2(start_point.x * width + i, start_point.y * height + j), ss_i, wall_sample)
			else:
				pass
	for i in range(0, door_dir.size()):
		if door_dir[i] == "down":
			tileMap.set_cell(Vector2(start_point.x * width + 5 , start_point.y * height + 0), ss_i, floor_sample)#tileMap.set_cell(Vector2(i,j),1,Vector2(3,1)) # floor
			tileMap.set_cell(Vector2(start_point.x * width + 4 , start_point.y * height + 0), ss_i, floor_sample)#tileMap.set_cell(Vector2(i,j),1,Vector2(3,1)) # floor
		elif door_dir[i] == "up" :
			tileMap.set_cell(Vector2(start_point.x * width + 5 , start_point.y * height + height -1), ss_i, floor_sample)#tileMap.set_cell(Vector2(i,j),1,Vector2(3,1)) # floor
			tileMap.set_cell(Vector2(start_point.x * width + 4 , start_point.y * height + height -1), ss_i, floor_sample)#tileMap.set_cell(Vector2(i,j),1,Vector2(3,1)) # floor
		elif door_dir[i] == "left":
			tileMap.set_cell(Vector2(start_point.x * width, start_point.y * height + 5), ss_i, floor_sample)#tileMap.set_cell(Vector2(i,j),1,Vector2(3,1)) # floor
			tileMap.set_cell(Vector2(start_point.x * width, start_point.y * height + 4), ss_i, floor_sample)#tileMap.set_cell(Vector2(i,j),1,Vector2(3,1)) # floorpass #	if i == start.x or j == start.y or i == end.x -1 or j == end.y -1 :
		elif door_dir[i] == "right":
			tileMap.set_cell(Vector2(start_point.x * width + width - 1 , start_point.y * height + 5), ss_i, floor_sample)#tileMap.set_cell(Vector2(i,j),1,Vector2(3,1)) # floor
			tileMap.set_cell(Vector2(start_point.x * width + width - 1 , start_point.y * height + 4), ss_i, floor_sample)
		#pass #tileMap.set_cell(Vector2(i,j), 1, Vector2(0,1)) # wall
			
	pass
