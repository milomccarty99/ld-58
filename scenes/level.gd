extends Node2D
var width = 500
var height = 500
var level_room_noise = FastNoiseLite.new()
@onready
var tileMap = $"../TileMapLayer"
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
	
func _ready()->void:
	var noise_texture = Noise.generate_scene_unique_id()
	level_room_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	level_room_noise.seed = randi()
	level_room_noise.frequency = .5
	var m = Array()
	m.resize(width * height)
	for i in range(0, width):
		for j in range(0,height):
			m[i + width * j] = i + width * j #initialize unique indices
			
	for i in range(0, width):
		for j in range(0,height):
			var strength = level_room_noise.get_noise_2d(i,j) #.get_noise_2D()
			if strength < 0.2 :
				#tileMap.set_cell(Vector2(i,j), 1, Vector2(3,1))
				pass
			elif strength < 0.4:
				m[i + width * j] = m[ i + width * (j-1)]
				tileMap.set_cell(Vector2(i,j), 1, Vector2(3,6))
			else: 
				tileMap.set_cell(Vector2(i,j), 1, Vector2(11,2))
				#m[i + width * j].direction = "up"
	for i in range(0, width):
		for j in range(0, height):
			pass
		pass
			#tileMap.set_cell(Vector2(i,j), 1, Vector2(3,1))
					
			
			 #initialize unique indices
	pass
