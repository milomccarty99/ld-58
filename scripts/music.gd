extends AudioStreamPlayer2D

func _ready() ->void:
	play()
	
func _process(delta : float)->void:
	if not playing:
		play()
