extends InteractionZone


func interaction():
	in_interaction = true
	# Используем функцию запроса на смену локации и указываем путь локации,
	# точку появления и направление игрока
	GameManager.request_level_change("res://Levels/TestLevel/test_level.tscn",
			"Spawn TestLevel",  Vector2.DOWN)
	
	in_interaction = false
