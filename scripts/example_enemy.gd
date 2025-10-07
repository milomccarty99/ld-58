extends Node2D

@onready var tile_map = $"../../Environment/TileMapLayer"
@onready var player = $"../../Player"
@onready var health_system = $"../../Player/Health"
@onready var world_is_oyster = $"../.."
@onready var atk_noise = $"../AudioStreamPlayer2D"
@onready var collectible_preload = preload("res://scenes/collectible.tscn")
#@onready var sprite_2d = $BullyBody/BloopEnemy
var astar_grid: AStarGrid2D
var is_moving : bool
var health = 2

func instantiate_loot(pos : Vector2):
	var object = collectible_preload.instantiate()
	while (object.position == Vector2() or not \
	tile_map.get_cell_tile_data(tile_map.local_to_map(object.position)).get_custom_data("walkable")):
		object.position.x = pos.x - 64 + 32 * randi()%5
		object.position.y = pos.y - 64 + 32 * randi()%5
	world_is_oyster.add_child(object)

func _ready():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(32,32)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	var appearance = randi() % 10
	if appearance < 5:
		$Sprite2D.texture = load("res://images/squirrel.png")
	elif appearance < 8:
		$Sprite2D.texture = load("res://images/rat.png")
	else:
		$Sprite2D.texture = load("res://images/seymore_fuzzbutt.png")
		
	var region_size = astar_grid.region.size
	var region_position = astar_grid.region.position

	for x in region_size.x:
		for y in region_size.y:
			var tile_position = Vector2i(
				x + region_position.x,
				y + region_position.y
			)
			var tile_data = tile_map.get_cell_tile_data(tile_position)

			if tile_data == null or not tile_data.get_custom_data("walkable"):
				astar_grid.set_point_solid(tile_position)

func _process(_delta):
	#if is_moving:
	#	return
	if health <= 0:
		for i in randi() % 3 + 1:
			instantiate_loot(position)
		queue_free()
		pass #world_is_oyster.add_child(instantiated_items)
	move()

func take_damage(amount : float):
	health -= amount

func attack():
	var is_player_hit = randi() % 5 == 1
	if is_player_hit :
		health_system.health -= 1
		atk_noise.play()
		$AtkIndicator.visible = true
	#health -= 1	
	player.turnTake = 0

func move():
	if player.turnTake <= 0 :
		#print("player has not made a turn... in my eyes")
		return
	#needs from and to vector2i
	var path = astar_grid.get_id_path(
		tile_map.local_to_map(position),
		tile_map.local_to_map(player.position)
	)
	#path = astar_grid.get_point_path(Vector2(position.x/32, position.y/32),Vector2(player.position.x / 32, player.position.y/32),false)
	#path.pop_front()
	if path.is_empty():
		print("path is empty")
		return
	var original_position = Vector2(position) # useful for tween
	if path.size() > 2:
		$AtkIndicator.visible = false
		position = tile_map.map_to_local(path[1])
		player.turnTake -= 1
		#sprite_2d.position = position
		is_moving = true
	else:
		attack()
		player.turnTake -= 1
		#player.turnTake = 0

func _physics_process(_delta):
	if is_moving:
		#sprite_2d.global_position = global_position #sprite_2d.global_position.move_toward(global_position,1)
		#if sprite_2d.global_position != global_position:
		#	return
		is_moving = false
		
