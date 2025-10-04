extends Node2D

var exampleenv = preload("res://scenes/procgenexample.tscn")
var noise = FastNoiseLite.new()

func _enter_tree() -> void:
	var noise_texture = Noise.generate_scene_unique_id()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = randi()
	noise.frequency = 0.05
	for i in range(0,50):
		for j in range(0,50):
			if noise.get_noise_2d(i,j) > .5:
				var new_env = exampleenv.instantiate()
				new_env.position.x = i * 32
				new_env.position.y = j * 32
				add_child(new_env)
	pass
