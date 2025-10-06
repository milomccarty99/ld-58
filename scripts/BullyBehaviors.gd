extends Node2D

@onready var tile_map = $"../Environment/TileMapLayer"
@onready var player = $"../Player"
@onready var sprite_2d = $BullyBody/BloopEnemy
var astar_grid: AStarGrid2D
var is_moving : bool

func _ready():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(32,32)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
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
	if is_moving:
		return
	move()
	
func move():
	#needs from and to vector2i
	var path = astar_grid.get_id_path(
		tile_map.local_to_map(global_position),
		tile_map.local_to_map(player.global.position)
	)
	
	path.pop_front()
	if path.is_empty():
		return
	var original_position = Vector2(global_position)
	global_position = tile_map.map_to_local(path[0])
	sprite_2d.global_position = original_position
	is_moving = true

func _physics_process(_delta):
	if is_moving:
		sprite_2d.global_position = sprite_2d.global_position.move_toward(global_position,1)
		if sprite_2d.global_position != global_position:
			return
		is_moving = false
