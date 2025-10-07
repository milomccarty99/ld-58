extends Node2D

var energy = 10
var speed = 100
var turnTake = 0
var score = 0
var equippedWeapon = "fist"
var tile_size = 32
var is_moving = false
var target_position: Vector2
@export var player : CharacterBody2D
@onready var tile_map = $"../Environment/TileMapLayer"

func _ready()->void:
	position.x = 32 + 16
	position.y = 32 + 16
	$"Health".set_health(4)
	


func _unhandled_input(event):
	if is_moving:
		return
	var direction = Vector2.ZERO
	if event.is_action_pressed("right"):
		direction = Vector2.RIGHT
		turnTake += 3
	elif event.is_action_pressed("left"):
		direction = Vector2.LEFT
		turnTake += 3
	elif event.is_action_pressed("up"):
		direction = Vector2.UP
		turnTake += 3
	elif event.is_action_pressed("down"):
		direction = Vector2.DOWN
		turnTake += 3
	elif event.is_action_pressed("attack"):
		attack()
		turnTake += 2
	if direction != Vector2.ZERO:
		move_to_tile(direction)

func move_to_tile(direction: Vector2):
	is_moving = true
	target_position = position + direction * tile_size
	if $"../Environment/BoilerRoom".is_world_position_valid(target_position):
		pass
	else:
		target_position -= tile_size * direction
	create_movement_tween()

#tweening the movement to make it bouncy
func create_movement_tween():
	var tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "position", target_position, 0.25)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	tween.finished.connect(on_tween_finished)

func on_tween_finished():
	is_moving = false

func swapWeapon():
	#Swapping Weapon, set attack range
	if Input.is_action_pressed("swap_weapon_L") || Input.is_action_pressed("swap_weapon_R"):
		turnTake = 1
		if equippedWeapon == "fist":
			#Swap weapon animation "stick"
			equippedWeapon = "stick"
		if equippedWeapon == "stick":
			#Swap weapon animation "rubberband"
			equippedWeapon = "fist"
pass

func attack():
	var nearest_enemy = null
	var nearest_enemy_distance = INF
	for enemy in $"../EnemyContainer".get_children():
		if enemy == $"../EnemyContainer/AudioStreamPlayer2D":
			pass
		elif enemy != null:
			var dist = abs(enemy.position.x - position.x) + \
			abs(enemy.position.y - position.y)
			if dist < nearest_enemy_distance:
				nearest_enemy = enemy
				nearest_enemy_distance = dist
	if nearest_enemy != null:
		$PlayerAtk.play()
		nearest_enemy.take_damage(.75)
	#Attacking
	#if Input.is_action_pressed("attack"):
	#	if equippedWeapon == "fist":
			#check for valid target
			#play animation if valid target is present
			#perform attack if valid target is present
	#		turnTake = 1
	#	if equippedWeapon == "stick":
			#check for valid target
			#play animation if valid target is present
			#perform attack if valid target is present
	#		turnTake = 1
pass
