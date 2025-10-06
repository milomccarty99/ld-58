extends Node2D

@onready var tile_map = $"root/World/Environment/TileMapLayer"
@onready var player = $"../../../Player"

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
	if player.turnTake == 1:
		var moves = astar_grid.get_point_path(Vector2(position.x / 32, position.y / 32),Vector2(player.position.x/ 32, player.position.y /32),false)
		position = moves[0]
		#position = moves[0]
#	move()
	
#func move():
#	var path = astar_grid.get_id_path(
#		tile_map.local_to_map(global_position),
#		tile_map.local_to_map(player.global.position)
#	)
