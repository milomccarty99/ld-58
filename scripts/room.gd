extends Node2D

#var start = Vector2(4,4)
#var end = Vector2(10,10)#var loc = Vector2(-1,-1)
var width = 10
var height = 10
var start_point = Vector2(0,0)
var wall_thickness = 1
var ss_i = 3
var wall_atlas_id = 4
var floor_sample = Vector2(3, 6)
var floor_samples = [Vector2(1,1), Vector2(3,1), Vector2(7,1), Vector2(1,2), Vector2(3,2), Vector2(7,2), Vector2(1,3), Vector2(3,3), Vector2(7,3), Vector2(9,3)]
var tile_splash = 0 # 0, 1, or 2 depending on room splash
var splash_offset = Vector2(0, 4)
var wall_splash_offset = Vector2(3, 0)
var wall_sample = Vector2(1, 5)
var door_dir = 0
var walls = 0
@onready
var tileMap = $"../../TileMapLayer"
@onready
var marker = $Marker
@onready
var label = $RichTextLabel
var roomtype = "peaceful" # types peaceful, trapped, janitor, dangerous
# dangerous+trapped, brutus, shop(end of each level)

func _process(_delta : float) -> void:
	label.text = roomtype

func _enter_tree()->void:
	
	pass
	
func _ready()->void:
	marker.position = Vector2(start_point.x * 32 * width, start_point.y * 32 * height)
	if roomtype != "peaceful":
		#marker.visible = true
		marker.frame = randi() % 10
	label.text = roomtype
	label.position = marker.position + Vector2(0, 0)
	for i in range(0, width):
		for j in range(0, height):
			
			tileMap.set_cell(Vector2(start_point.x * width + i,start_point.y * height + j),ss_i, floor_samples[0] + tile_splash * splash_offset)
			var running_walls = walls
			if i == width - 1 and running_walls % 8 == running_walls: # right wall
				tileMap.set_cell(Vector2(start_point.x * width + i, start_point.y * height + j), wall_atlas_id, wall_sample + wall_splash_offset * tile_splash )
				tileMap.set_cell(Vector2(start_point.x * width + i, start_point.y * height + j), 1, Vector2(0,0))
			running_walls = running_walls % 8
			if  j == height - 1 and running_walls % 4 == running_walls: # down wall
				tileMap.set_cell(Vector2(start_point.x * width + i, start_point.y * height + j), wall_atlas_id, wall_sample + wall_splash_offset * tile_splash)
				tileMap.set_cell(Vector2(start_point.x * width + i, start_point.y * height + j), 1, Vector2(0,0))
			running_walls = running_walls % 4
			if i == 0 and running_walls % 2 == running_walls: # left wall
				tileMap.set_cell(Vector2(start_point.x * width + i, start_point.y * height + j), wall_atlas_id, wall_sample + wall_splash_offset * tile_splash)
				tileMap.set_cell(Vector2(start_point.x * width + i, start_point.y * height + j), 1, Vector2(0,0))
			running_walls = running_walls % 2
			if j == 0 and running_walls % 1 == running_walls: # up  wall
				tileMap.set_cell(Vector2(start_point.x * width + i, start_point.y * height + j), wall_atlas_id, wall_sample)# + wall_splash_offset * tile_splash)
				tileMap.set_cell(Vector2(start_point.x * width + i, start_point.y * height + j), 5, Vector2(1,5))
				tileMap.set_cell(Vector2(start_point.x * width + i, start_point.y * height + j), 1, Vector2(0,0))
			else:
				pass
				

	# to-do fix door detection. not sure if this needs to be fixed in door_dir
	for i in range(0, width):
		for j in range(0, height):
			#if door_dir % 8 != door_dir:
			tileMap.set_cell(Vector2(start_point.x * width + 5 , start_point.y * height + 0), ss_i, floor_samples[9] + tile_splash * splash_offset)# up
			tileMap.set_cell(Vector2(start_point.x * width + 4 , start_point.y * height + 0), ss_i, floor_samples[9] + tile_splash * splash_offset)#
			#door_dir = door_dir % 8
			#if door_dir % 4 != door_dir:
			tileMap.set_cell(Vector2(start_point.x * width, start_point.y * height + 5), ss_i, floor_samples[9] + tile_splash * splash_offset)# left 
			tileMap.set_cell(Vector2(start_point.x * width, start_point.y * height + 4), ss_i, floor_samples[9] + tile_splash * splash_offset)#
			#door_dir = door_dir % 4
			#if door_dir % 2 != door_dir:
			tileMap.set_cell(Vector2(start_point.x * width + 5 , start_point.y * height + height -1), ss_i, floor_samples[9] + tile_splash * splash_offset)# down
			tileMap.set_cell(Vector2(start_point.x * width + 4 , start_point.y * height + height -1), ss_i, floor_samples[9] + tile_splash * splash_offset)#
			#door_dir = door_dir % 2
			#if door_dir % 1 != door_dir:
			tileMap.set_cell(Vector2(start_point.x * width + width - 1 , start_point.y * height + 5), ss_i, floor_samples[9] + tile_splash * splash_offset)# right
			tileMap.set_cell(Vector2(start_point.x * width + width - 1 , start_point.y * height + 4), ss_i, floor_samples[9] + tile_splash * splash_offset)
		#pass #tileMap.set_cell(Vector2(i,j), 1, Vector2(0,1)) # wall
			
