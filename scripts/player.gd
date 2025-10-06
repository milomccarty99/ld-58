extends Node2D

var energy = 10
var speed = 100
var turnTake
var equippedWeapon = "fist"
var tile_size = 32
var is_moving = false
var target_position: Vector2
@export var player : CharacterBody2D
@onready var tile_map = $"../Environment/TileMapLayer"

func _ready()->void:
	position.x = 32 + 16
	position.y = 32 + 16


func _unhandled_input(event):
	if is_moving:
		return
	var direction = Vector2.ZERO
	if event.is_action_pressed("right"):
		direction = Vector2.RIGHT
	elif event.is_action_pressed("left"):
		direction = Vector2.LEFT
	elif event.is_action_pressed("up"):
		direction = Vector2.UP
	elif event.is_action_pressed("down"):
		direction = Vector2.DOWN
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
	#Attacking
	if Input.is_action_pressed("attack"):
		if equippedWeapon == "fist":
			#check for valid target
			#play animation if valid target is present
			#perform attack if valid target is present
			turnTake = 1
		if equippedWeapon == "stick":
			#check for valid target
			#play animation if valid target is present
			#perform attack if valid target is present
			turnTake = 1
pass
