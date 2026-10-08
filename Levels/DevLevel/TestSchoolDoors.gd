extends InteractionZone


func interaction():
	in_interaction = true
	
	GameManager.request_level_change("res://Levels/TestLevel/test_level.tscn",
			"Spawn TestLevel",  Vector2.DOWN)
	
	in_interaction = false
