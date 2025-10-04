extends Node2D
var width = 10
var height = 10
var level_room_noise = FastNoiseLite.new()
var m
@onready
var tileMap = $"../TileMapLayer"
#@onready
#var connections = Array().resize()


class Room:
	var index
	var direction = "center"
	#var pos = Vector2(0,0) stored in an array
	pass
# Boiler room : 
#	- two rooms in the center with boilers
# 	- room made of boxes

func _enter_tree() -> void:
	
	pass
# naive approach
func join_rooms(from_room : Vector2, to_room : Vector2)->void:
	if (to_room.x >= 0 and to_room.x < width and to_room.y >= 0 and to_room.y < height):
		var old_index = m[to_room.x + width * to_room.y]
		var new_index = m[from_room.x + width * from_room.y]
		for i in range(0, width):
			for j in range(0,height):
				if m[i + width * j] == old_index:
					m[i + width * j] = new_index
				#m[to_room.x + width * to_room.y] = m[from_room.x + width * from_room.y];
		pass

	
func _ready()->void:
	#var noise_texture = Noise.generate_scene_unique_id()
	level_room_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX 
	level_room_noise.seed = randi()
	level_room_noise.frequency = .5
	m = Array()
	m.resize((width + 1) * (height + 1))
	for i in range(0, width):
		for j in range(0,height):
			m[i + width * j] = i + width * j #initialize unique indices
			
	for i in range(0, width):
		for j in range(0,height):
			var strength = level_room_noise.get_noise_2d(i,j) #.get_noise_2D()
			if strength < 0.2 :
				#tileMap.set_cell(Vector2(i,j), 1, Vector2(3,1))
				#sjoin_rooms(Vector2(i,j), Vector2(i,j-1))
				
				pass
			elif strength < 0.4:
				join_rooms(Vector2(i,j), Vector2(i,j-1))
				#m[i + width * j] = m[ i + width * (j-1)]
				#tileMap.set_cell(Vector2(i,j), 1, Vector2(3,6))
			elif strength < 0.6:
				join_rooms(Vector2(i,j), Vector2(i,j+1))#m[i + width * j] = m[ i + width * (j + 1)]
			elif strength < 0.8:
				join_rooms(Vector2(i,j), Vector2(i-1,j))#m[1 + width * j] = m[(i-1) + width * j]
			else:
				join_rooms(Vector2(i,j), Vector2(i+1,j))#m[1 + width * j] = m[(i+1) + width * j]
				#tileMap.set_cell(Vector2(i,j), 1, Vector2(11,2))
				#m[i + width * j].direction = "up"
	for i in range(0, width):
		for j in range(0, height):
			var tile_indexed = [Vector2(4,2), Vector2(3,6), Vector2(11,2)]
			var splash = m[i + width * j] % tile_indexed.size()
			tileMap.set_cell(Vector2(i,j),1, tile_indexed[splash])
		pass
			#tileMap.set_cell(Vector2(i,j), 1, Vector2(3,1))
					
			
			 #initialize unique indices
	pass
