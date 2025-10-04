extends Node2D

var energy = 10
var speed = 100

func _enter_tree() -> void:
	position.x = 16 #+ 320
	position.y = 16 #+ 320

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		position.y -= 32
	if Input.is_action_just_pressed("down"):
		position.y += 32
	if Input.is_action_just_pressed("left"):
		position.x -= 32
	if Input.is_action_just_pressed("right"):
		position.x += 32
	#print (" x,y {}{}", position.x, position.y)
	pass
