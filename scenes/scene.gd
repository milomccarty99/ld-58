extends CanvasLayer

signal scene_changed
@export var scene_name = "scene"

func _on_ChangeScene() -> void:
	emit_signal("scene_changed",scene_name)
	
	
