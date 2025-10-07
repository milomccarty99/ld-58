class_name Health
extends Node
signal max_health_changed(diff: int) 
signal health_changed(diff: int)
signal health_depleted
@export var healing_per_unit: int = 2
@export var max_health: int = 3 : set = set_max_health, get = get_max_health
@export var health = max_health

func set_max_health(value: int):
	var clamped_value = 1 if value <=0 else value
	if not clamped_value == max_health:
		var difference = clamped_value - max_health
		max_health = value
		max_health_changed.emit(difference)
	if health > max_health:
		health = max_health

func get_max_health() -> int:
	
	return max_health

func set_health(value: int):
	if value < health: 
		return
	var clamped_value = clampi(value,0,max_health)
	if clamped_value != health:
		var difference = clamped_value - health
		health = value
		health_changed.emit(difference)
	#if health < health.max_health:
	#	health+healing_per_unit
func show_healthbar():
	if health ==3:
		$"../../UI/Control/FullHeart1".visible=true
		$"../../UI/Control/FullHeart2".visible=true
		$"../../UI/Control/FullHeart3".visible=true
	if health ==2:
		$"../../UI/Control/FullHeart1".visible=true
		$"../../UI/Control/FullHeart2".visible=true
		$"../../UI/Control/FullHeart3".visible=false
	if health ==1:
		$"../../UI/Control/FullHeart1".visible=true
		$"../../UI/Control/FullHeart2".visible=false
		$"../../UI/Control/FullHeart3".visible=false
	if health <= 0:
		$"../../UI/Control/FullHeart1".visible=false
		$"../../UI/Control/FullHeart2".visible=false
		$"../../UI/Control/FullHeart3".visible=false

func _heal() -> void:
	health.health += healing_per_unit
	
func _process(_delta : float):
	show_healthbar()
