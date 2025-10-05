extends Node2D

var energy = 10
var speed = 100
var turnTake
var equippedWeapon = "fist"

func _enter_tree() -> void:
	position.x = 0 #+ 320aaa
	position.y = 0 #+ 320

func _process(_delta: float) -> void:
	#get_node("CollisionShape2D")
	#print($CollisionShape2D)
	var has_moved : bool = false;
	if Input.is_action_just_pressed("up"):
		position.y -= 32
		turnTake = 1
		has_moved = true
	if Input.is_action_just_pressed("down"):
		position.y += 32
		turnTake = 1
		has_moved = true
	if Input.is_action_just_pressed("left"):
		position.x -= 32
		turnTake = 1
		has_moved = true
	if Input.is_action_just_pressed("right"):
		position.x += 32
		turnTake = 1
		has_moved = true
	#print (" x,y {}{}", position.x, position.y)
	if has_moved :
		pass # $CheeseWalk.play()
	
	pass

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
