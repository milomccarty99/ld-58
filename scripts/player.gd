extends Node2D

var energy = 10
var speed = 100
var turnTake
var equippedWeapon = "fist"
var weaponRange = "1"

func _enter_tree() -> void:
	position.x = 16 #+ 320aaa
	position.y = 16 #+ 320

func _process(_delta: float) -> void:
	#get_node("CollisionShape2D")
	print($CollisionShape2D)
	if Input.is_action_just_pressed("up"):
		position.y -= 32
		turnTake = 1
	if Input.is_action_just_pressed("down"):
		position.y += 32
		turnTake = 1
	if Input.is_action_just_pressed("left"):
		position.x -= 32
		turnTake = 1
	if Input.is_action_just_pressed("right"):
		position.x += 32
		turnTake = 1
	#print (" x,y {}{}", position.x, position.y)
	pass

func swapWeapon():
	#Swapping Weapon, set attack range
	if Input.is_action_pressed("swap_weapon_L"):
		turnTake = 1
		if equippedWeapon == "fist":
			#Swap weapon animation "stick"
			equippedWeapon = "stick"
			weaponRange = "2"
		if equippedWeapon == "stick":
			#Swap weapon animation "rubberband"
			equippedWeapon = "rubberband"
			weaponRange = "5"
		if equippedWeapon == "rubberband":
			#Swap weapon animation "fist"
			equippedWeapon = "fist"
			weaponRange = "1"
	if Input.is_action_pressed("swap_weapon_R"):
		turnTake = 1
		if equippedWeapon == "fist":
			#Swap weapon animation "rubberband"
			equippedWeapon = "rubberband"
			weaponRange = "5"
		if equippedWeapon == "stick":
			#Swap weapon animation "fist"
			equippedWeapon = "fist"
			weaponRange = "1"
		if equippedWeapon == "rubberband":
			#Swap weapon animation "stick"
			equippedWeapon = "stick"
			weaponRange = "2"
pass

func attack(): 	
	#Attacking
	if Input.is_action_pressed("attack"):
		if equippedWeapon == "fist":
			#check range
			#check for valid target
			#play animation
			#perform attack if valid target is present
			turnTake = 1
		if equippedWeapon == "stick":
			#check range
			#check durability
			#play animation
			#play animation
			#perform attack if valid target is present
			turnTake = 1
		if equippedWeapon == "rubberband":
			#check range
			#check ammunition count
			#play animation
			#perform attack if valid target is present
			#reduce ammo
			turnTake = 1
pass
