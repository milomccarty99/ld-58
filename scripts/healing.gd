extends Node

@export var health: Health
@export var healing_per_unit: int = 2
#func _ready() -> void:
#	health.health_changed.connect(_start_healing)
	
#func _start_healing(_diff : int) -> void:

	#if health.health < health.max_health:
	#	health.health+healing_per_unit


func _heal() -> void:
	health.health += healing_per_unit
