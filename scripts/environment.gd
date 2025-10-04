extends Node2D

#setting: Abandoned factory
#Levels: 
#* School Storage
#* Backroad
#* Factory yard
#* First floor factory
#* Boiler room

var exampleenv = preload("res://scenes/procgenexample.tscn")
var noise = FastNoiseLite.new()

# Needs t0 be in environment : 
#	shop (x/level) - racoondsdsssssssssssssssssssssddaw
#	artifacts:
#			- Lunchbox (may contain 1 or 2 ingredients)
#			- Thermas - (reduce chill effect ???)
#			- Water bottle (instant restore)
#			- Trading cards
#	sadnwich pieces -- exactly 2 of each
#		- bread
#		- cheese
#		- condiments
#		- "meat"
# 	flavor :
#		Crates
#		Barrels
#		Conveyor belt (with variants)
#		boiler (depending on level)
#		coal crate
# 	coins $5 to win
#		quarter
#		dollar bill (elusive)



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
