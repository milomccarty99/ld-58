extends Node2D


var speed = 100

func _process(delta: float) -> void:
	if Input.is_action_pressed("up"):
		position.y -= delta * speed
	if Input.is_action_pressed("down"):
		position.y += delta * speed
	if Input.is_action_pressed("left"):
		position.x -= delta * speed
	if Input.is_action_pressed("right"):
		position.x += delta * speed
	print (" x,y {}{}", position.x, position.y)
	pass
