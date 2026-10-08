extends InteractionZone


func interaction():
	in_interaction = true
	
	if GameManager.test_flags.has_key:
		GameManager.request_level_change("res://Levels/DevLevel/dev_level.tscn",
				"Spawn TestSchoolDoors", Vector2.DOWN)
	else:
		label.text = "Нужен ключ"
	
	in_interaction = false
