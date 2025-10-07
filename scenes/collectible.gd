extends Node2D


@onready var player = $"../Player"
@onready var tile_map = $"../Environment/TileMapLayer"

func _ready()->void:
	var texture_to_disp = randi()%10
	$Sprite2D.frame = texture_to_disp

func _process(delta: float) -> void:
	print(" (" , tile_map.local_to_map(player.position).x , ", " , tile_map.local_to_map(player.position).y , ") "
	 , "  " , " (" , tile_map.local_to_map(position).x , ", " , tile_map.local_to_map(position).y , ") ")
	if tile_map.local_to_map(player.position) == tile_map.local_to_map(position):
		print("collecting item")
		player.score += 1
		$"../ItemPickupNoise".play()
		queue_free()
