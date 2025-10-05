extends Node2D
@onready var s_b = $StartButton
@onready var c_b = $CreditsButton
@onready var q_b = $QuitButton
@onready var m_b = $MuteButton

func _ready()->void:
	s_b.pressed.connect(_on_sb_pressed)
	c_b.pressed.connect(_on_cb_pressed)
	q_b.pressed.connect(_on_qb_pressed)
	
func _process(delta: float) -> void:
	#if s_b.pressed :
	#	get_tree().change_scene_to_file("res://scenes/world.tscn")
	#	pass
	#if c_b.button_down:
	#	pass
	#	#get_tree().change_scene_to_file("res://scenes/credits.tscn")
	#if q_b.button_down:
		#get_tree().quit()
	#	pass
	if m_b.pressed:
		if m_b.button_pressed:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),0)
		else: 
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),1)
			
func _on_sb_pressed()->void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_cb_pressed()->void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	
func _on_qb_pressed()->void:
	get_tree().quit()
