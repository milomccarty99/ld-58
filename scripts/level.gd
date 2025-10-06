extends Node2D
var width = 5
var height = 5
var level_room_noise = FastNoiseLite.new()
var m
var included
var room_walls
@onready
var tileMap = $"../TileMapLayer"
var room_scene_preload = preload("res://scenes/room.tscn")
var enemy_preload = preload("res://scenes/nondescript_enemy.tscn")
@onready
var enter_room = Vector2(0,0)
var exit_room = Vector2(width -1, height - 1)
var extra_interests  # Brutus, Supply Closet, Janitor room ;;; be sure to check against in existing room -- esp. themed rooms
var articulated_ex_interests = ["Brutus", "Supply-Closet", "Janitor"]
var articulated_room_types = ["Peaceful", "Trapped", "Dangerous", "Dangerous-Trapped"] # to-do Boss room and shop
var doors
var door_count = 0
@onready
var rng = RandomNumberGenerator.new()

#var connections = Array().resize()


class Room:
	var index
	var direction = "center"
	#var pos = Vector2(0,0) stored in an array
	pass
# Boiler room : 
#	- two rooms in the center with boilers
# 	- room made of boxes


func is_world_position_valid(worldPos : Vector2) ->bool :
	var translateCoord = (worldPos - Vector2(16,16)) / 32
	return is_tile_position_valid(translateCoord)
	
func is_tile_position_valid(pos: Vector2) -> bool:
	var tileId = $"../TileMapLayer".get_cell_atlas_coords(pos)
	if tileId.x == -1 and tileId.y == -1:
		return false
	return is_tile_id_walkable(tileId)
	
	
func is_tile_id_walkable(tileId ) -> bool:
	print(tileId)
	var valid_walkable_tiles = $Room.floor_samples # ------ bad coding. using a nonexistent room as reference 
	for t in range(0, 3): # 3 possible tile sets are offset by 5 each
		for i in range(0, valid_walkable_tiles.size() ):
			if valid_walkable_tiles[i].x + (0 *t) == tileId.x and valid_walkable_tiles[i].y + (4 *t) == tileId.y:
				return true
	return false
	
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
				#m[to_room.x + width * to_room.y] = m[from_room.x room_prefab+ width * from_room.y];
		pass
		
func is_room_valid(room : Vector2)->bool:
	return room.x >= 0 and room.x < width and room.y >= 0 and room.y < height

func include_joined_room(start_room : Vector2)->void:
	#if (start_room.x >= 0 and start_room.x < width and start_room.y >= 0 and start_room.y < height):
	var index_id = m[start_room.x + width * start_room.y]
	for i in range(0, width):
		for j in range(0, height):
			if m[i + width * j] == index_id :
				included[i + width * j] = true
					
func look_for_walls(room : Vector2)->int:
	var index_id = m[room.x + width * room.y]
	var running_total = 0
	if (is_room_valid(Vector2(room.x , room.y - 1)) and index_id == m[room.x + width * (room.y - 1)]) : #up
		running_total += 1
	if (is_room_valid(Vector2(room.x - 1, room.y)) and index_id == m[(room.x - 1) + width * room.y]) : #left
		running_total += 2
	if (is_room_valid(Vector2(room.x ,room.y + 1)) and index_id == m[room.x + width * (room.y + 1)]) : #down
		running_total += 4
	if (is_room_valid(Vector2(room.x + 1, room.y)) and index_id == m[(room.x + 1) + width * room.y]) : # right
		running_total += 8
	return running_total
	
	
func look_for_doors(room : Vector2)->int: # using included
	#var index_id = m[room.x + width * room.y]
	var running_total = 0
	if (is_room_valid(Vector2(room.x , room.y - 1)) and included[room.x + width * (room.y - 1)]) : #up
		running_total += 1
	if (is_room_valid(Vector2(room.x - 1, room.y)) and included[(room.x - 1) + width * room.y]) : #left
		running_total += 2
	if (is_room_valid(Vector2(room.x ,room.y + 1)) and included[room.x + width * (room.y + 1)]) : #down
		running_total += 4
	if (is_room_valid(Vector2(room.x + 1, room.y)) and included[(room.x + 1) + width * room.y]) : #right
		running_total += 8
	return running_total 
func is_closer_distance(from_room: Vector2, to_room: Vector2, closest_distance : float)-> float:
	if is_room_valid(from_room):
		var dist = abs(from_room.x - to_room.x) + abs(from_room.y - to_room.y)
		if dist < closest_distance:
			return dist
	return INF
	
func find_next_room_in_path(to_room : Vector2)->bool:
	 # find next nearest room to an existing included point
	# add door to door array
	# returns true if room was found
	# returns false if room was not yet found
	var closest_included_room_point = Vector2(enter_room) # we take care of this at every included point very inefficient
	var closest_new_room_point = Vector2(enter_room)
	var closest_distance = INF
	if (to_room.x >= 0 and to_room.x < width and to_room.y >= 0 and to_room.y < height):
		#pathfinding next room
		for i in range(0, width):
			for j in range(0,height):
				if (included[i + width * j]):
					var distance = abs((i-to_room.x)) + abs(j - to_room.y)
					if distance <= closest_distance:
						closest_distance = distance
						closest_included_room_point = Vector2(i,j)
						#var closest_direction = "none"
						var new_closest_distance = INF
						# N,S,E,W but in random order
						var order = [0 , 1, 2, 3]
						for messy in range(0,4):
							var scramble = rng.randi() %4
							var order_temp = order[0]
							order[0] = order[scramble]
							order[scramble] = order_temp
						
						for iter in range(0, 4):
							#var order = rng.randi() % 4
							if order[iter] == 0:
								new_closest_distance = is_closer_distance(Vector2(i,j - 1), to_room, closest_distance)
								if new_closest_distance < closest_distance :
									closest_distance = new_closest_distance
									closest_new_room_point = Vector2(i,j - 1)
							if order[iter] == 1:
								new_closest_distance = is_closer_distance(Vector2(i,j + 1), to_room, closest_distance)
								if new_closest_distance < closest_distance :
									closest_distance = new_closest_distance
									closest_new_room_point = Vector2(i,j + 1)
							if order[iter] == 2:
								new_closest_distance = is_closer_distance(Vector2(i - 1, j), to_room, closest_distance)
								if new_closest_distance < closest_distance :
									closest_distance = new_closest_distance
									closest_new_room_point = Vector2(i - 1, j)
							if order[iter] == 3:
								new_closest_distance = is_closer_distance(Vector2(i + 1, j), to_room, closest_distance)
								if new_closest_distance < closest_distance :
									closest_distance = new_closest_distance
									closest_new_room_point = Vector2(i + 1, j)
		include_joined_room(closest_new_room_point)
		
	doors.resize(door_count + 2)
	doors[door_count] = Vector4(closest_included_room_point.x, closest_included_room_point.y, closest_new_room_point.x, closest_new_room_point.y)
	doors[door_count+ 1] = Vector4(closest_new_room_point.x, closest_new_room_point.y, closest_included_room_point.x, closest_included_room_point.y)
	door_count += 2
	return included[to_room.x + width * to_room.y]
	
func get_free_room()->Vector2:
	return Vector2(rng.randi()%width, rng.randi()%height)
	
func _ready()->void:
	#var noise_texture = Noise.generate_scene_unique_id()
	level_room_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX 
	level_room_noise.seed = randi()
	level_room_noise.frequency = .5
	rng.seed = hash("boiler1")
	extra_interests = [get_free_room(), get_free_room(), get_free_room()]
	m = Array()
	m.resize(width * height + 1)
	included = Array()
	included.resize(width * height)
	room_walls = Array()
	room_walls.resize(width * height)
	doors = Array()
	
	for i in range(0, width):
		for j in range(0,height):
			m[i + width * j] = i + width * j #initialize unique indices
			included[i + width * j] = false # initialize to false 
			
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
	while (not find_next_room_in_path(exit_room)):
		pass
	for i in range(0, extra_interests.size()):
		while(not find_next_room_in_path(extra_interests[i])):
			pass
	
	for i in range(0, width):
		for j in range(0, height):
			if (included[i + width * j]):
				var tile_indexed = [Vector2(4,2), Vector2(3,6), Vector2(11,2)] # ------ replace these with newer tiles
				var splash = m[i + width * j] % tile_indexed.size()# 0, 1 or 2
				#tileMap.set_cell(Vector2(i,j),1, tile_indexed[splash])
				var room_to_instance = room_scene_preload.instantiate()
				room_to_instance.start_point = Vector2(i,j)
				var found_art_int = false
				for interest in extra_interests.size():
					if Vector2(i,j) == extra_interests[interest]:
						room_to_instance.roomtype = articulated_ex_interests[interest]
						found_art_int = true
				if not found_art_int :
					room_to_instance.roomtype = articulated_room_types[rng.randi() % articulated_room_types.size()]
				room_to_instance.tile_splash = splash
				room_to_instance.door_dir = look_for_doors(Vector2(i,j))
				room_to_instance.walls = look_for_walls(Vector2(i,j))
				# "Peaceful", "Trapped", "Dangerous", "Dangerous-Trapped"]
				if room_to_instance.roomtype == "Peaceful":
					pass # no enemies 
				if room_to_instance.roomtype == "Trapped":
					pass
					#spawn_enemies(Vector2(i,j), 1)
					pass # spawn 1 trapper (?)
				if room_to_instance.roomtype == "Dangerous":
					pass
					#spawn_enemies(Vector2(i,j), 3)
					pass # spawn 3
				if room_to_instance.roomtype == "Dangerous-Trapped":
					pass
					#spawn_enemies(Vector2(i,j), 4)
					pass # spawn 4 - 1 trappers 3 enemies
				
				
				
				add_child(room_to_instance)
			#tileMap.set_cell(Vector2(i,j), 1, Vector2(3,1))
	
			
			 
	pass
func spawn_enemies(room_coords : Vector2,num_base_enemies : int, num_trappers: int = 0, num_janitors : int = 0)->void:
	var start_pos = Vector2(1,1)
	for base_enemy in range(0,num_base_enemies):
		var base_enemy_to_instance = enemy_preload.instantiate()
		base_enemy_to_instance.starting_pos = Vector2(room_coords.x * 32 * width * start_pos.x, room_coords.y * 32 * width * start_pos.y )
		add_child(base_enemy_to_instance)
		start_pos += Vector2(1,1)
		
	pass
