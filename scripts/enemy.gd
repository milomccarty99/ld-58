extends Node2D


var energy = 10
var speed = 100
var turnTake
var equippedWeapon = "fist"
var weaponRange = "1"
var health = 2
@onready
var timer_delete_later = $DeleteMe
@export var sequence : String = "uuddlrlraa"
@export var step : int = 0
@export var starting_pos = Vector2(0,0)

func _enter_tree() -> void:
	position.x = 16 + starting_pos.x #+ 320aaa
	position.y = 16 + starting_pos.y #+ 320

func _ready() ->void:
	timer_delete_later.autostart = true
	
func _process(delta: float) -> void:
	if timer_delete_later.time_left <= 0.05:
		timer_delete_later.start(0.25)
		sequence_step()
		
		

func sequence_step()->void:
	var move_to_go = sequence[step%sequence.length()]
	if move_to_go == 'u':
		position.y -= 32
	elif move_to_go == 'd':
		position.y += 32
	elif move_to_go == 'l':
		position.x -= 32
	elif move_to_go == 'r':
		position.x += 32
	elif move_to_go == 'a':
		attack()
	step +=1 #increment
		
func attack()->void:
	pass
