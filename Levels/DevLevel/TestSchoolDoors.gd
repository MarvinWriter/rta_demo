extends InteractionZone


func interaction():
	GameManager.request_level_change("res://Levels/TestLevel/test_level.tscn",
			"Spawn TestLevel",  Vector2.DOWN)
